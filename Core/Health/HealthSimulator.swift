import Foundation
import Observation

@Observable
@MainActor
class HealthSimulator {
    static let shared = HealthSimulator()
    
    var currentSample: VitalSample
    var weeklyData: [VitalSample] = []
    
    private var timer: Timer?
    
    private init() {
        // Initial state for Pulmonary Fibrosis patient
        let now = Date()
        self.currentSample = VitalSample(
            date: now,
            respiratoryRate: 22.4, // Tachypnea is common
            hrv: 38.0, // Lower baseline HRV
            oxygenLevel: 94.0 // 93-96% is stable for PF
        )
        
        generateWeeklyData()
        startSimulation()
    }
    
    func generateWeeklyData() {
        let calendar = Calendar.current
        var samples: [VitalSample] = []
        
        for i in (0..<7).reversed() {
            let date = calendar.date(byAdding: .day, value: -i, to: Date()) ?? Date()
            let sample = VitalSample(
                date: date,
                respiratoryRate: Double.random(in: 19...24),
                hrv: Double.random(in: 30...45),
                oxygenLevel: Double.random(in: 93...96)
            )
            samples.append(sample)
        }
        
        self.weeklyData = samples
    }
    
    private func startSimulation() {
        // Simulation disabled to keep data stable as per user request.
        // Data is generated once on init and stays fixed.
    }
    
    private func updateCurrentStats() {
        // No-op: Data remains steady.
    }
}

extension Double {
    func clamped(to range: ClosedRange<Double>) -> Double {
        return min(max(self, range.lowerBound), range.upperBound)
    }
}
