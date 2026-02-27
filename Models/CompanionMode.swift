import SwiftUI

enum CompanionMode: String, CaseIterable, Identifiable {
    case empathetic = "Empathetic"
    case motivating = "Motivating"
    case clinical   = "Clinical"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .empathetic: return "heart.fill"
        case .motivating: return "bolt.fill"
        case .clinical:   return "cross.case.fill"
        }
    }
    
    var description: String {
        switch self {
        case .empathetic: return "Gentle & calm experience."
        case .motivating: return "High-energy training."
        case .clinical:   return "Precise data tracking."
        }
    }
    
    var color: Color {
        switch self {
        case .empathetic: return .indigo // Replaced .pink (reddish) with .indigo to match the theme
        case .motivating: return .teal
        case .clinical:   return .blue
        }
    }
}
