import SwiftUI
import UIKit

public enum InkColorOption: String, CaseIterable, Identifiable {
    case adaptive
    case teal
    case blue
    case purple
    case orange
    case red
    
    public var id: String { rawValue }
    
    public var label: String {
        switch self {
        case .adaptive: return "Adaptive"
        case .teal: return "Teal"
        case .blue: return "Blue"
        case .purple: return "Purple"
        case .orange: return "Orange"
        case .red: return "Red"
        }
    }
    
    public func uiColor(for colorScheme: ColorScheme) -> UIColor {
        switch self {
        case .adaptive: return colorScheme == .dark ? .black : .white
        case .teal: return .systemTeal
        case .blue: return .systemBlue
        case .purple: return .systemPurple
        case .orange: return .systemOrange
        case .red: return .systemRed
        }
    }
    
    @ViewBuilder
    public func colorPreview(for colorScheme: ColorScheme) -> some View {
        Circle()
            .fill(Color(uiColor: uiColor(for: colorScheme)))
    }
}
