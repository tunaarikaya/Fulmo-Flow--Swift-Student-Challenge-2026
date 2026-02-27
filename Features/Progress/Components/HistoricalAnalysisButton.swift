import SwiftUI

struct HistoricalAnalysisButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Historical Analysis")
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                    Text("View your complete medical history and past results")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right.circle.fill")
                    .font(.system(.largeTitle))
                    .foregroundStyle(.teal)
            }
            .padding(32)
            .insightPanel(tint: .teal.opacity(0.08))
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(.isButton)
        }
        .buttonStyle(.plain)
    }
}
