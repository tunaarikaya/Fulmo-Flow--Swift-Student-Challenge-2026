import SwiftUI

class HuffViewModel: BaseBreathingViewModel {
    override var exerciseType: BreathingExercise { .huff }
    
    override func phaseCycle() -> [(SessionPhase, Int)] {
        return [(.inhale, 4), (.hold, 3), (.exhale, 3)]
    }
}
