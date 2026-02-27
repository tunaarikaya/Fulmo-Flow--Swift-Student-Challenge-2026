import SwiftUI

struct DailyInsightCard: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    @State private var isAnimating = false
    
    let text: String = "Your overall respiratory profile has been stable over the past 3 days, with low stress markers (HRV) and optimal oxygenation. Conforming to your current exercise routine is highly recommended."
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                // Animated AI Sphere (Breathing Style)
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.indigo, .indigo.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .blur(radius: 8)
                    
                    Circle()
                        .fill(.ultraThinMaterial)
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [.white.opacity(0.6), .white.opacity(0.2)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.5
                                )
                        )
                        .overlay(
                            Circle()
                                .stroke(Color.indigo.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: Color.indigo.opacity(0.3), radius: 10)
                }
                .frame(width: 44, height: 44)
                .scaleEffect(isAnimating ? 1.05 : 0.95)
                .accessibilityHidden(true)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("DAILY INSIGHT")
                        .font(.system(.subheadline, design: .rounded, weight: .bold))
                        .foregroundStyle(Color.indigo)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "cpu")
                            .font(.system(.caption2))
                        Text("ON-DEVICE ALGORITHM")
                            .font(.system(.caption, design: .rounded, weight: .semibold))
                    }
                    .foregroundStyle(.secondary)
                }
            }
            
            Text(text)
                .font(.system(.subheadline, design: .rounded, weight: .medium))
                .foregroundStyle(.primary)
                .lineSpacing(6)
        }
        .padding(32)
        .frame(maxWidth: .infinity, alignment: .leading)
        .insightPanel(tint: .indigo.opacity(colorScheme == .dark ? 0.12 : 0.08))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Daily AI Insight. On-Device Algorithm. \(text)")
        .onAppear {
            if !reduceMotion {
                withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            }
        }
    }
}

#Preview {
    DailyInsightCard()
        .padding()
}
