import SwiftUI

class PursedLipViewModel: BaseBreathingViewModel {
    override var exerciseType: BreathingExercise { .pursedLip }
    
    override func phaseCycle() -> [(SessionPhase, Int)] {
        return [(.inhale, 2), (.exhale, 4)]
    }
}
