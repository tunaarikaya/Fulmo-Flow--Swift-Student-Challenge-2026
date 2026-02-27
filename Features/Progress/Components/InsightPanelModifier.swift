import SwiftUI

struct InsightPanelModifier: ViewModifier {
    let tint: Color
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.colorScheme) private var colorScheme
    
    private var cornerRadius: CGFloat { 32 }
    
    private var baseFillStyle: AnyShapeStyle {
        if reduceTransparency {
            return AnyShapeStyle(Color(uiColor: .secondarySystemBackground))
        }
        if colorScheme == .dark {
            return AnyShapeStyle(.ultraThinMaterial)
        }
        return AnyShapeStyle(Color(red: 0.84, green: 0.88, blue: 0.92).opacity(0.92))
    }
    
    private var borderColor: Color {
        colorScheme == .dark ? .white.opacity(0.14) : .black.opacity(0.14)
    }
    
    private var innerHighlight: Color {
        colorScheme == .dark ? .white.opacity(0.06) : .white.opacity(0.45)
    }
    
    private var shadowColor: Color {
        .black.opacity(colorScheme == .dark ? 0.14 : 0.09)
    }
    
    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(baseFillStyle)
                    .overlay {
                        if !reduceTransparency {
                            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                                .fill(tint)
                        }
                    }
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(borderColor, lineWidth: 1.2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .inset(by: 1.5)
                    .stroke(innerHighlight, lineWidth: 1)
            )
            .shadow(color: shadowColor, radius: 18, x: 0, y: 8)
    }
}

extension View {
    func insightPanel(tint: Color) -> some View {
        self.modifier(InsightPanelModifier(tint: tint))
    }
}
