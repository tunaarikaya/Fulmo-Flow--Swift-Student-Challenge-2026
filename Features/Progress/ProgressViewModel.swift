import SwiftUI

@Observable
@MainActor
class ProgressViewModel {
    private let simulator = HealthSimulator.shared
    
    var currentSample: VitalSample {
        simulator.currentSample
    }
    
    var weeklyData: [VitalSample] {
        simulator.weeklyData
    }
    
    var lungStatus: String {
        let oxygen = currentSample.oxygenLevel
        if oxygen >= 93 {
            return "Stable"
        } else if oxygen >= 90 {
            return "Monitor"
        } else {
            return "Distress"
        }
    }
    
    var statusColor: Color {
        let oxygen = currentSample.oxygenLevel
        if oxygen >= 93 {
            return .teal
        } else if oxygen >= 90 {
            return .orange
        } else {
            return .red
        }
    }
}
