import SwiftUI
import Combine

@MainActor
class BaseBreathingViewModel: ObservableObject {
    @Published var breathScale: CGFloat = 1.0
    @Published var sessionTimeRemaining: Int = 60
    @Published var sessionComplete: Bool = false
    
    // Continuous smooth progress from 1.0 down to 0.0
    @Published var exactProgress: Double = 1.0
    @Published var showMicrophoneAlert: Bool = false

    @Published var currentPhase: SessionPhase = .inhale
    @Published var phaseTimeRemaining: Int = 0

    @Published var maxStrength: CGFloat = 0.0
    @Published var bestExhaleDuration: TimeInterval = 0.0

    let breathEngine = BreathingEngine()
    private var timer: Timer?
    
    // Combine subscription for instantaneous audio-to-visuals reactivity
    private var cancellables = Set<AnyCancellable>()
    private var isAudioBound: Bool = false
    
    // To be overridden by subclasses
    func phaseCycle() -> [(SessionPhase, Int)] { return [] }
    var exerciseType: BreathingExercise { .pursedLip }
    
    // Calculated total duration based on phase cycles
    var sessionTotalSeconds: Int {
        let cyclePairs = phaseCycle()
        let totalCycleTime = cyclePairs.reduce(0) { $0 + $1.1 }
        
        // Return 20 to 25 seconds total, but rounded to completing full cycles if possible.
        // E.g., if cycle is 10s -> total 20s. If cycle is 6s -> total 24s.
        guard totalCycleTime > 0 else { return 60 }
        
        let targetTime = 25
        let numberOfCycles = targetTime / totalCycleTime
        return max(totalCycleTime, totalCycleTime * numberOfCycles) // at least one cycle, or round down to nearest complete cycle under 25s limit
    }
    
    @Published var phaseChangeTrigger: UUID = UUID()
    
    private var phaseCycleStorage: [(SessionPhase, Int)] = []
    private var phaseIndex: Int = 0
    
    func startSession() {
        sessionComplete = false
        sessionTimeRemaining = sessionTotalSeconds
        exactProgress = 1.0
        maxStrength = 0
        bestExhaleDuration = 0

        phaseCycleStorage = phaseCycle()
        phaseIndex = 0
        if !phaseCycleStorage.isEmpty {
            currentPhase = phaseCycleStorage[0].0
            phaseTimeRemaining = phaseCycleStorage[0].1
        }
        phaseChangeTrigger = UUID()
        showMicrophoneAlert = false

        breathEngine.requestPermissionsAndStart { [weak self] in
            // PAUSE workout instantly!
            self?.timer?.invalidate()
            self?.timer = nil
            self?.showMicrophoneAlert = true
        }

        // 1. Setup lightning-fast reactive audio bindings for 43fps liquid sphere interaction
        // Ensure SwiftUI lifecycle redraws don't aggressively drop the connection mid-workout.
        if !isAudioBound {
            cancellables.removeAll()
            breathEngine.$displayIntensity
                .receive(on: DispatchQueue.main) // DispatchQueue resists heavy UI render dropping better than RunLoop
                .sink { [weak self] liveIntensity in
                    guard let self = self else { return }
                    
                    if liveIntensity > 0.01 {
                        if self.currentPhase == .exhale || self.exerciseType == .huff {
                            self.breathScale = 1.0 + (liveIntensity * 1.2)
                            self.maxStrength = max(self.maxStrength, liveIntensity)
                        } else {
                            self.breathScale = 1.0 + (liveIntensity * 0.35)
                        }
                    } else {
                        self.breathScale = 1.0
                    }
                }
                .store(in: &cancellables)
            isAudioBound = true
        }

        // Only start the fallback UI timer here if the user hasn't explicitly denied
        // This timer handles ONLY the game loop logic (seconds, phase tracking), NOT the audio rendering.
        let sessionTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.sessionTick()
            }
        }
        RunLoop.main.add(sessionTimer, forMode: .common)
        timer = sessionTimer
    }

    private var tickCounter = 0
    func sessionTick() {
        // Smoothly update exact progress by sub-second increments (every 0.1s tick)
        if exactProgress > 0 {
            let decrement = 0.1 / Double(sessionTotalSeconds)
            exactProgress = max(0, exactProgress - decrement)
        }

        tickCounter += 1
        if tickCounter >= 10 {
            tickCounter = 0
            
            if sessionTimeRemaining > 0 { sessionTimeRemaining -= 1 }
            if phaseTimeRemaining > 0 { phaseTimeRemaining -= 1 }

            if phaseTimeRemaining <= 0 && !phaseCycleStorage.isEmpty {
                let nextIndex = (phaseIndex + 1) % phaseCycleStorage.count
                phaseIndex = nextIndex
                currentPhase = phaseCycleStorage[nextIndex].0
                phaseTimeRemaining = phaseCycleStorage[nextIndex].1
                phaseChangeTrigger = UUID()
            }

            if sessionTimeRemaining <= 0 {
                timer?.invalidate()
                timer = nil
                breathEngine.stopMonitoring()
                sessionComplete = true
            }
        }
    }

    func endSession() {
        timer?.invalidate()
        timer = nil
        isAudioBound = false // Reset binding capability for the NEXT full run
        breathEngine.stopMonitoring()
        withAnimation(.spring()) {
            sessionComplete = true
        }
    }
}
