import SwiftUI

public struct CheckInBackground: View {
    public var reduceTransparency: Bool
    @State private var animate = false
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    public init(reduceTransparency: Bool) {
        self.reduceTransparency = reduceTransparency
    }
    
    public var body: some View {
        ZStack {
            if reduceTransparency {
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()
            } else {
                (
                    colorScheme == .dark
                    ? Color.black.opacity(0.7)
                    : Color(red: 0.92, green: 0.95, blue: 0.97)
                )
                    .ignoresSafeArea()
                RadialGradient(
                    colors: [Color.cyan.opacity(colorScheme == .dark ? 0.12 : 0.07), .clear],
                    center: animate ? .topLeading : .bottomTrailing,
                    startRadius: 80,
                    endRadius: 500
                )
                RadialGradient(
                    colors: [Color.teal.opacity(colorScheme == .dark ? 0.1 : 0.06), .clear],
                    center: animate ? .bottomTrailing : .topLeading,
                    startRadius: 80,
                    endRadius: 400
                )
                if colorScheme == .light {
                    Color.black.opacity(0.04).ignoresSafeArea()
                }
            }
        }
        .onAppear {
            if !reduceMotion {
                withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                    animate.toggle()
                }
            }
        }
        .onChange(of: reduceMotion) { _, newValue in
            if newValue {
                withAnimation { animate = false }
            } else {
                withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                    animate = true
                }
            }
        }
    }
}
