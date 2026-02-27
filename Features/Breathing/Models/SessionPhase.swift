import Foundation

// MARK: - Session Phase (medically accurate breathing cycle)
enum SessionPhase: String, CaseIterable {
    case inhale = "Inhale"
    case hold = "Hold"
    case exhale = "Exhale"
    
    func displayName(for exercise: BreathingExercise?) -> String {
        if exercise == .huff, self == .exhale { return "Forceful Huff" }
        return rawValue
    }
}
