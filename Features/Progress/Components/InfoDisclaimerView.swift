import SwiftUI

struct InfoDisclaimerView: View {
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "applewatch.side.right")
                .font(.largeTitle)
                .foregroundStyle(.teal)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Clinical Data Source")
                    .font(.system(.headline, design: .rounded, weight: .semibold))
                Text("In production, this data is retrieved via HealthKit from your Apple Watch and iPhone. Mock data is used here for playground preview.")
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(24)
        .insightPanel(tint: .teal.opacity(0.06))
    }
}
