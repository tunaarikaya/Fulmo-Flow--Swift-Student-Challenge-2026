import SwiftUI

public struct SettingsCardModifier: ViewModifier {
    public var borderAccent: Color?
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    public init(borderAccent: Color? = nil) {
        self.borderAccent = borderAccent
    }

    private var fill: AnyShapeStyle {
        if reduceTransparency {
            return AnyShapeStyle(Color(uiColor: .secondarySystemBackground))
        }
        return colorScheme == .dark
            ? AnyShapeStyle(.ultraThinMaterial)
            : AnyShapeStyle(Color(uiColor: .systemBackground))
    }

    private var border: Color {
        if let accent = borderAccent {
            return colorScheme == .dark ? accent.opacity(0.35) : accent.opacity(0.22)
        }
        return colorScheme == .dark ? .white.opacity(0.1) : .black.opacity(0.07)
    }

    public func body(content: Content) -> some View {
        content
            .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(fill))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(border, lineWidth: 1))
            .shadow(
                color: .black.opacity(colorScheme == .dark ? 0.12 : 0.06),
                radius: 8, x: 0, y: 3
            )
    }
}

public extension View {
    func settingsCard(borderAccent: Color? = nil) -> some View {
        self.modifier(SettingsCardModifier(borderAccent: borderAccent))
    }
}
