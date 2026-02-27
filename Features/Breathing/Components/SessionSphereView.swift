import SwiftUI

struct SessionSphereView: View {
    let phase: SessionPhase
    let phaseTimeRemaining: Int
    let phaseName: String
    let exerciseColor: Color
    var isComplete: Bool = false
    var baseScale: CGFloat = 1.0 // Real-time audio driven scale
    
    @State private var shimmer = false
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    
    private var scheduledScale: CGFloat {
        if isComplete { return 1.0 }
        switch phase {
        case .inhale: return 1.15
        case .hold: return 1.05
        case .exhale: return 0.85
        }
    }
    
    var body: some View {
        ZStack {
            // Dynamic sphere: expand on inhale, shimmer on hold, shrink on exhale
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [exerciseColor, exerciseColor.opacity(0.5)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .blur(radius: phase == .inhale && !isComplete ? 25 : 15)
                
                Circle()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.5), .white.opacity(0.15)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .overlay(
                        Circle()
                            .stroke(exerciseColor.opacity(0.4), lineWidth: 1)
                    )
                    .shadow(color: exerciseColor.opacity(0.35), radius: phase == .inhale && !isComplete ? 30 : 18)
            }
            // 1) Combined audio + phase scale (merged to prevent animation conflicts)
            .scaleEffect(baseScale * scheduledScale)
            .animation(.spring(response: 0.15, dampingFraction: 0.7), value: baseScale)
            .animation(.easeInOut(duration: 1.2), value: scheduledScale)
            // 2) Hold phase subtle shimmer
            .scaleEffect(phase == .hold && !isComplete ? (shimmer ? 1.02 : 0.98) : 1.0)
            .animation(phase == .hold && !isComplete ? .easeInOut(duration: 0.4).repeatForever(autoreverses: true) : .default, value: shimmer)
            
            // Phase label + countdown (large, rounded typography); "Complete" when session ended
            VStack(spacing: 12) {
                Text(isComplete ? "Complete" : phaseName)
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .foregroundColor(.white)
                
                Text(isComplete ? "0" : "\(phaseTimeRemaining)")
                    .font(.system(.largeTitle, design: .rounded, weight: .black))
                    .foregroundColor(.white)
                    .contentTransition(.numericText())
            }
        }
        .frame(width: 280, height: 280)
        .onChange(of: phase) { _, _ in shimmer.toggle() }
        .onAppear { if phase == .hold { shimmer = true } }
    }
}
