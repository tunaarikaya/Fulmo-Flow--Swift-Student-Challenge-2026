import Foundation
import AVFoundation

/// The observed states of the user's breathing during a session
enum BreathingState: String {
    case idle = "Idle"
    case exhaling = "Exhaling"
    case coughed = "CoughDetected"
}

/// A dedicated, isolated class to process audio buffers off the main thread.
/// By keeping this completely separate from @MainActor, we avoid Swift 6 runtime
/// queue assertions (`_dispatch_assert_queue_fail`) inside the real-time audio thread.
final class AudioAnalyzer: @unchecked Sendable {
    var onUpdate: ((Float, Float) -> Void)?
    
    func process(buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData?[0] else { return }
        
        let frameLength = Int(buffer.frameLength)
        let stride = Int(buffer.stride)
        
        var sumSquares: Float = 0.0
        var peak: Float = 0.0
        
        // Fast calculations without memory allocations
        for i in 0..<frameLength {
            let sample = channelData[i * stride]
            sumSquares += sample * sample
            let absSample = abs(sample)
            if absSample > peak {
                peak = absSample
            }
        }
        
        let rms = sqrt(sumSquares / Float(frameLength))
        let dbRMS = 20 * log10(rms)
        let dbPeak = 20 * log10(peak)
        
        // Seamlessly return to Main loop using standard mechanisms
        DispatchQueue.main.async { [weak self] in
            self?.onUpdate?(dbRMS, dbPeak)
        }
    }
}

/// A real-time audio analysis engine designed to detect continuous exhalations (huffs/blows)
/// and sudden spikes (coughs/sputters) using the device microphone.
class BreathingEngine: ObservableObject, @unchecked Sendable {
    /// Current real-time state of the user's breathing. Safely updated on the Main thread.
    @MainActor @Published var currentState: BreathingState = .idle
    
    /// Smoothed intensity of the current audio input. Safely updated on the Main thread.
    @MainActor @Published var displayIntensity: CGFloat = 0.0
    
    /// True if the user has explicitly denied microphone access.
    @MainActor @Published var isMicrophoneDenied: Bool = false
    
    private let audioEngine = AVAudioEngine()
    private let analyzer = AudioAnalyzer()
    
    private let queue = DispatchQueue(label: "com.pulmoflow.audioengine", qos: .userInitiated)
    private var isRecording = false
    
    // Configurable Thresholds
    private let noiseFloorRMS: Float = -40.0 // dB threshold to consider "silence"
    private let peakCoughThreshold: Float = -5.0 // dB threshold for a sudden, loud spike
    
    // State Tracking
    private var breathStartTime: Date?
    private let requiredExhaleDuration: TimeInterval = 0.5 // Seconds of sustained noise
    private let coughSpikeWindow: TimeInterval = 0.2 // Max duration of a spike to count as a Cough
    
    // Audio Bus tracking
    private let processingBus = 0
    private let bufferSize: AVAudioFrameCount = 1024 // Roughly 43Hz updates for 60FPS fluid UI at 44.1kHz
    
    init() {
        // Wire up the async analyzer callback to the state machine
        analyzer.onUpdate = { [weak self] rms, peak in
            self?.evaluateBreathingState(rms: rms, peak: peak)
        }
    }
    
    func requestPermissionsAndStart(onDenied: @escaping @MainActor () -> Void = {}) {
        AVAudioApplication.requestRecordPermission { [weak self] granted in
            guard let self = self else { return }
            guard granted else {
                print("Microphone access denied. Breathing engine cannot function.")
                Task { @MainActor in
                    self.isMicrophoneDenied = true
                    onDenied()
                }
                return
            }
            Task { @MainActor in
                self.isMicrophoneDenied = false
            }
            // Move entirely off the main thread to configure the engine
            self.queue.async { [weak self] in
                self?.setupAndStartEngine()
            }
        }
    }
    
    private func setupAndStartEngine() {
        guard !isRecording else { return }
        
        // 1. Configure audio session
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker, .allowBluetoothA2DP])
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to configure AVAudioSession: \(error)")
            return
        }
        
        let inputNode = audioEngine.inputNode
        let hwFormat = inputNode.inputFormat(forBus: processingBus)
        let sampleRate = hwFormat.sampleRate > 0 ? hwFormat.sampleRate : 44100.0
        
        guard let safeFormat = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1) else {
            print("Failed to create safe audio format.")
            return
        }
        
        inputNode.removeTap(onBus: processingBus)
        
        let audioAnalyzer = self.analyzer
        
        // 2. Install Tap
        inputNode.installTap(onBus: processingBus, bufferSize: bufferSize, format: safeFormat) { (buffer, time) in
            audioAnalyzer.process(buffer: buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
            self.isRecording = true
            
            // 3. Update main actor state
            Task { @MainActor in
                self.currentState = .idle
            }
        } catch {
            print("Could not start audio engine: \(error.localizedDescription)")
            inputNode.removeTap(onBus: processingBus)
        }
    }
    
    func stopMonitoring() {
        queue.async { [weak self] in
            guard let self = self, self.isRecording else { return }
            
            self.audioEngine.inputNode.removeTap(onBus: self.processingBus)
            self.audioEngine.stop()
            try? AVAudioSession.sharedInstance().setActive(false)
            
            self.isRecording = false
            self.breathStartTime = nil
            
            Task { @MainActor in
                self.currentState = .idle
                self.displayIntensity = 0.0
            }
        }
    }
    
    private func evaluateBreathingState(rms: Float, peak: Float) {
        let safeRMS = rms.isFinite ? rms : -100.0
        let safePeak = peak.isFinite ? peak : -100.0
        
        // Typical breathing/blowing RMS is around -35dB to -10dB. 
        // We remap -45dB -> 0.0 and -10dB -> 1.0 for a highly sensitive, punchy UI.
        let normalizedIntensity = max(0.0, min(1.0, CGFloat((safeRMS + 45.0) / 35.0)))
        let now = Date()
        
        Task { @MainActor in
            // Smooth the intensity for 43Hz (0.85 retention for buttery drop-offs)
            self.displayIntensity = (self.displayIntensity * 0.7) + (normalizedIntensity * 0.3)
            
            // Check for Cough
            if safePeak > self.peakCoughThreshold {
                if let start = self.breathStartTime {
                    if now.timeIntervalSince(start) < self.coughSpikeWindow {
                        self.currentState = .coughed
                        self.breathStartTime = nil
                        return
                    }
                } else {
                    self.breathStartTime = now
                }
            }
            
            // Check for Exhaling
            if safeRMS > self.noiseFloorRMS {
                if self.breathStartTime == nil {
                    self.breathStartTime = now
                } else if let start = self.breathStartTime {
                    if now.timeIntervalSince(start) >= self.requiredExhaleDuration && self.currentState != .exhaling {
                        self.currentState = .exhaling
                    }
                }
            } else {
                self.breathStartTime = nil
                if self.currentState != .idle {
                    self.currentState = .idle
                }
            }
        }
    }
}
