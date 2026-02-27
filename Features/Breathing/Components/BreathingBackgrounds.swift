import SwiftUI

// MARK: - Legacy / Helper Views (Preserved)

struct LiquidGlassOrbView: View {
    @AppStorage("selectedCompanionMode") private var selectedModeRaw: String = CompanionMode.empathetic.rawValue
    @State private var animate = false
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    private var orbColor: Color {
        let mode = CompanionMode(rawValue: selectedModeRaw) ?? .empathetic
        return mode.color
    }
    
    var body: some View {
        ZStack {
            // Background glow that matches color
            Circle()
                .fill(orbColor.opacity(0.15))
                .blur(radius: 40)
                
            Circle()
                .fill(
                    LinearGradient(
                        colors: [orbColor, orbColor.opacity(0.4)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .blur(radius: animate ? 30 : 15)
            
            Circle()
                .fill(.ultraThinMaterial)
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.5), .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
                .shadow(color: orbColor.opacity(0.35), radius: 25)
        }
        .onAppear {
            if !reduceMotion {
                withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                    animate.toggle()
                }
            }
        }
        .onChange(of: reduceMotion) { _, newValue in
            if newValue {
                withAnimation { animate = false }
            } else {
                withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) { animate = true }
            }
        }
    }
}

struct BreathingPulseBackground: View {
    @State private var animate = false
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    private var baseBackground: Color {
        if colorScheme == .dark { return .black }
        return Color(red: 0.91, green: 0.95, blue: 0.97)
    }
    
    private var tealGlow: Color {
        Color.teal.opacity(colorScheme == .dark ? 0.1 : 0.06)
    }
    
    private var blueGlow: Color {
        Color.blue.opacity(colorScheme == .dark ? 0.1 : 0.05)
    }
    
    var body: some View {
        ZStack {
            baseBackground.ignoresSafeArea()
            
            RadialGradient(
                colors: [tealGlow, .clear],
                center: animate ? .topLeading : .bottomTrailing,
                startRadius: 100,
                endRadius: 600
            )
            
            RadialGradient(
                colors: [blueGlow, .clear],
                center: animate ? .bottomTrailing : .topLeading,
                startRadius: 100,
                endRadius: 500
            )
            
            if colorScheme == .light {
                Color.black.opacity(0.04).ignoresSafeArea()
            }
        }
        .onAppear {
            if !reduceMotion {
                withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                    animate.toggle()
                }
            }
        }
        .onChange(of: reduceMotion) { _, newValue in
            if newValue {
                withAnimation { animate = false }
            } else {
                withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) { animate = true }
            }
        }
    }
}
