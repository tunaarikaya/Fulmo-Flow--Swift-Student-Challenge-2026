import SwiftUI

struct LungStatusHeader: View {
    let statusColor: Color
    let lungStatus: String
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("LUNG STATUS")
                    .font(.system(.caption, design: .rounded, weight: .bold))
                    .foregroundStyle(.secondary)
                
                HStack(spacing: 12) {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 12, height: 12)
                        .shadow(color: statusColor.opacity(0.8), radius: 6)
                        .overlay(
                            Circle()
                                .stroke(statusColor.opacity(0.4), lineWidth: 4)
                                .scaleEffect(1.2)
                        )
                    
                    Text(lungStatus)
                        .font(.system(.title2, design: .rounded, weight: .bold))
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("Last Synced")
                    .font(.system(.caption, design: .rounded, weight: .semibold))
                    .foregroundStyle(.secondary)
                Text(Date().formatted(date: .omitted, time: .shortened))
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
            }
        }
        .padding(32)
        .insightPanel(tint: .teal.opacity(colorScheme == .dark ? 0.18 : 0.12))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Lung Status: \(lungStatus). Last updated just now.")
    }
}
