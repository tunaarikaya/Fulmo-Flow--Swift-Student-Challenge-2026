import SwiftUI

struct MeshGradientBackground: View {
    @Environment(\.colorScheme) private var colorScheme
    
    private var baseBackground: Color {
        if colorScheme == .dark { return .black }
        return Color(red: 0.92, green: 0.95, blue: 0.97)
    }
    
    private var firstGlow: Color {
        colorScheme == .dark ? .indigo.opacity(0.2) : .indigo.opacity(0.08)
    }
    
    private var secondGlow: Color {
        colorScheme == .dark ? .cyan.opacity(0.15) : .cyan.opacity(0.07)
    }
    
    var body: some View {
        ZStack {
            baseBackground.ignoresSafeArea()
            
            // Simulating a "Mesh" of glowing orbs
            Canvas { context, size in
                context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(baseBackground))
            }
            
            RadialGradient(
                colors: [firstGlow, .clear],
                center: .topLeading,
                startRadius: 0,
                endRadius: 600
            )
            .ignoresSafeArea()
            
            RadialGradient(
                colors: [secondGlow, .clear],
                center: .bottomTrailing,
                startRadius: 0,
                endRadius: 800
            )
            .ignoresSafeArea()
            
            if colorScheme == .light {
                Color.black.opacity(0.04).ignoresSafeArea()
            }
        }
    }
}
