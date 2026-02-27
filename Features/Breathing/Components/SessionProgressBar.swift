import SwiftUI

struct SessionProgressBar: View {
    // Current progress (1.0 to 0.0)
    let progress: Double
    let tint: Color
    
    // Smoothness: instead of snapping to the integer seconds passed down by progress, 
    // we use a linear continuous animation that matches the remaining time to reach 0.
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    )
                
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(tint.opacity(0.9))
                    .frame(width: max(0, geo.size.width * progress))
                    // .linear is used here to create a continuous shrinking, rather than .easeInOut which would stutter 
                    .animation(.linear(duration: 1.0), value: progress)
            }
        }
        .frame(height: 8)
    }
}
