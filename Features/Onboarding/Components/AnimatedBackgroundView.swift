import SwiftUI

struct AnimatedBackgroundView: View {
    @State private var animate = false
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.teal.opacity(colorScheme == .dark ? 0.3 : 0.16))
                .frame(width: 400, height: 400)
                .offset(x: animate ? 100 : -100, y: animate ? -150 : 150)
                .blur(radius: 80)

            Circle()
                .fill(Color.purple.opacity(colorScheme == .dark ? 0.2 : 0.1))
                .frame(width: 300, height: 300)
                .offset(x: animate ? -150 : 150, y: animate ? 100 : -100)
                .blur(radius: 60)

            Circle()
                .fill(Color.blue.opacity(colorScheme == .dark ? 0.2 : 0.1))
                .frame(width: 350, height: 350)
                .offset(x: animate ? 50 : -50, y: animate ? 200 : -200)
                .blur(radius: 70)
        }
        .onAppear {
            if !reduceMotion {
                withAnimation(.easeInOut(duration: 7).repeatForever(autoreverses: true)) {
                    animate.toggle()
                }
            }
        }
        .onChange(of: reduceMotion) { _, newValue in
            if newValue {
                withAnimation { animate = false }
            } else {
                withAnimation(.easeInOut(duration: 7).repeatForever(autoreverses: true)) {
                    animate = true
                }
            }
        }
    }
}
