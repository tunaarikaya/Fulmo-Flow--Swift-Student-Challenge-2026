import SwiftUI

struct LiquidGlassOrb: View {
    var tint: Color = .teal
    @State private var animate = false
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [tint, tint.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .scaleEffect(0.9)
                .blur(radius: animate ? 20 : 10)

            Circle()
                .fill(.ultraThinMaterial)
                .scaleEffect(1.0)
                .overlay(
                    Circle()
                        .stroke(colorScheme == .dark ? Color.white.opacity(0.4) : Color.black.opacity(0.12), lineWidth: 1.5)
                )
                .shadow(color: tint.opacity(0.4), radius: 20)

            Circle()
                .stroke(tint.opacity(0.3), lineWidth: 2)
                .scaleEffect(animate ? 1.3 : 1.0)
                .opacity(animate ? 0 : 0.5)
        }
        .scaleEffect(animate ? 1.08 : 1.0)
        .onAppear {
            if !reduceMotion {
                withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                    animate.toggle()
                }
            }
        }
        .onChange(of: reduceMotion) { _, newValue in
            if newValue {
                withAnimation { animate = false }
            } else {
                withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                    animate = true
                }
            }
        }
    }
}
