import SwiftUI

enum BreathingExercise: String, CaseIterable, Identifiable {
    case pursedLip = "Pursed-Lip Flow"
    case rescue = "Rescue Rhythm"
    case huff = "The Huff Challenge"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .pursedLip: return "wind"
        case .rescue: return "bolt.heart.fill"
        case .huff:      return "waveform.and.mic"
        }
    }

    var subtitle: String {
        switch self {
        case .pursedLip: return "Slow down your exhale to open up airways."
        case .rescue: return "A panic-brake for acute shortness of breath."
        case .huff:      return "Clear mucus and strengthen your lungs."
        }
    }

    var color: Color {
        switch self {
        case .pursedLip: return .teal
        case .rescue: return .orange
        case .huff:      return .indigo
        }
    }
    
    var medicalBenefit: String {
        switch self {
        case .pursedLip: return "This technique helps release trapped air and makes breathing easier. It's especially helpful when you feel short of breath."
        case .rescue: return "When shortness of breath triggers anxiety and a rapid heart rate, this rhythmic 'box breathing' pattern helps you regain control, slow your pulse, and stop a panic attack."
        case .huff:      return "A gentle alternative to coughing. It moves mucus up your airways safely, making it much easier to clear your lungs."
        }
    }
    
    var instructions: [String] {
        switch self {
        case .pursedLip:
            return [
                "Inhale normally through your nose.",
                "Pucker your lips as if you're whistling.",
                "Exhale slowly through your mouth. Make the exhale twice as long as the inhale."
            ]
        case .rescue:
            return [
                "Inhale deeply through your nose for 4 seconds.",
                "Hold your breath for 2 seconds to steady your heart rate.",
                "Exhale completely for 4 seconds. Repeat until you feel your panic fade away."
            ]
        case .huff:
            return [
                "Take a medium-deep breath in.",
                "Force the air out fast with an open mouth, saying 'Hah!' (like fogging a mirror).",
                "Repeat 2-3 times, then relax. Stop if you feel dizzy."
            ]
        }
    }
}
