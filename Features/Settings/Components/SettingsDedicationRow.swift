import SwiftUI

struct SettingsDedicationRow: View {
    @Binding var showingDedication: Bool
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isAnimating = false

    var body: some View {
        Button {
            showingDedication = true
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(colorScheme == .dark ? 0.2 : 0.12))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "heart.fill")
                        .font(.system(.body))
                        .foregroundStyle(.orange)
                        .scaleEffect(isAnimating ? 1.15 : 1.0)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("For My Grandfather")
                        .font(.system(.headline, design: .rounded, weight: .bold))
                        .foregroundStyle(.primary)
                    Text("A special dedication to my inspiration")
                        .font(.system(.footnote, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // Colored, bold arrow to subconsciously draw attention and indicate "TAP ME"
                Image(systemName: "chevron.right")
                    .font(.system(.subheadline, weight: .bold))
                    .foregroundStyle(.orange.opacity(0.9))
            }
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(.isButton)
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            // Increased the opacity of the border accent strictly for this card so it pops
            .settingsCard(borderAccent: .orange.opacity(0.6))
        }
        .buttonStyle(.plain)
        .onAppear {
            if !reduceMotion {
                withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            }
        }
    }
}
