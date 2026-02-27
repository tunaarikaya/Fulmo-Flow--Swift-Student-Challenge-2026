import SwiftUI

struct GlassCardModifier: ViewModifier {
    var cornerRadius: CGFloat = 24
    @Environment(\.colorScheme) private var colorScheme
    
    private var borderColor: Color {
        colorScheme == .dark ? .white.opacity(0.2) : .black.opacity(0.08)
    }
    
    private var shadowColor: Color {
        .black.opacity(colorScheme == .dark ? 0.1 : 0.06)
    }
    
    func body(content: Content) -> some View {
        content
            .background(colorScheme == .dark ? AnyShapeStyle(.ultraThinMaterial) : AnyShapeStyle(.thinMaterial))
            .overlay {
                if colorScheme == .light {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(Color.black.opacity(0.04))
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(borderColor, lineWidth: 1)
            )
            .shadow(color: shadowColor, radius: 10, x: 0, y: 5)
    }
}

struct LiquidGlassModifier: ViewModifier {
    var tint: Color = .clear
    var opacity: Double = 0.1
    var cornerRadius: CGFloat = 32
    
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    @Environment(\.colorScheme) private var colorScheme
    
    private var reducedBackground: Color {
        colorScheme == .dark ? .black.opacity(0.8) : Color(uiColor: .secondarySystemBackground)
    }
    
    private var borderGradient: [Color] {
        colorScheme == .dark
        ? [.white.opacity(0.4), .white.opacity(0.1), .clear]
        : [.white.opacity(0.8), .black.opacity(0.08), .clear]
    }
    
    private var shadowColor: Color {
        .black.opacity(colorScheme == .dark ? 0.15 : 0.08)
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    if reduceTransparency {
                        reducedBackground
                    } else {
                        Rectangle().fill(colorScheme == .dark ? AnyShapeStyle(.ultraThinMaterial) : AnyShapeStyle(.thinMaterial))
                        tint.opacity(opacity)
                        if colorScheme == .light {
                            Color.black.opacity(0.05)
                        }
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: borderGradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
            .shadow(color: shadowColor, radius: 20, x: 0, y: 10)
    }
}

extension View {
    func glassCard(cornerRadius: CGFloat = 24) -> some View {
        self.modifier(GlassCardModifier(cornerRadius: cornerRadius))
    }
    
    func liquidGlass(tint: Color = .clear, opacity: Double = 0.1, cornerRadius: CGFloat = 32) -> some View {
        self.modifier(LiquidGlassModifier(tint: tint, opacity: opacity, cornerRadius: cornerRadius))
    }
    
    func glassEffect(cornerRadius: CGFloat = 32, tint: Color = .clear) -> some View {
        self.modifier(LiquidGlassModifier(tint: tint, opacity: 0.15, cornerRadius: cornerRadius))
    }
}
