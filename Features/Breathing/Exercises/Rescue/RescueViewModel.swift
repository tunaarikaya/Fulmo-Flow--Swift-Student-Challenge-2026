import SwiftUI

class RescueViewModel: BaseBreathingViewModel {
    override var exerciseType: BreathingExercise { .rescue }
    
    override func phaseCycle() -> [(SessionPhase, Int)] {
        return [(.inhale, 4), (.hold, 2), (.exhale, 4)]
    }
}
