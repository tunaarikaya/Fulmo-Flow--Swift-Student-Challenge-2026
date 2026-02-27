import SwiftUI

class BreathingViewModel: ObservableObject {
    @Published var selectedExercise: BreathingExercise? = nil
    @Published var activeSessionExercise: BreathingExercise? = nil
    @Published var showDetail: Bool = false

    func select(_ exercise: BreathingExercise) {
        guard activeSessionExercise == nil else { return }
        selectedExercise = exercise
        showDetail = true
    }
    
    func closeDetail() {
        showDetail = false
        selectedExercise = nil
    }

    func startSession() {
        guard let exercise = selectedExercise else { return }
        activeSessionExercise = exercise
        closeDetail()
    }
    
    func endSession() {
        withAnimation(.spring()) {
            activeSessionExercise = nil
        }
    }
}
