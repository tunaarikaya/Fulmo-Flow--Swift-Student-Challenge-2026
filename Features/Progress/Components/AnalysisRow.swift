import SwiftUI

struct AnalysisRow: View {
    let sample: VitalSample
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            // Date Header
            HStack {
                Text(sample.date.formatted(.dateTime.weekday(.wide).day().month().year()))
                    .font(.system(.headline, design: .rounded, weight: .bold))
                Spacer()
                Text("VERIFIED")
                    .font(.system(.caption2, design: .rounded, weight: .bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.teal.opacity(0.2))
                    .foregroundStyle(.teal)
                    .clipShape(Capsule())
            }
            .padding(24)
            .background(Color.primary.opacity(colorScheme == .dark ? 0.08 : 0.05))
            
            Divider().background(Color.primary.opacity(colorScheme == .dark ? 0.14 : 0.1))
            
            // Metrics Row
            HStack(spacing: 40) {
                MetricMiniItem(label: "RESPIRATION", value: String(format: "%.1f", sample.respiratoryRate), unit: "BPM", color: .cyan)
                MetricMiniItem(label: "HRV SCORE", value: String(format: "%.0f", sample.hrv), unit: "ms", color: .indigo)
                MetricMiniItem(label: "OXYGEN", value: String(format: "%.0f%%", sample.oxygenLevel), unit: "SpO2", color: .teal)
            }
            .padding(32)
        }
        .insightPanel(tint: colorScheme == .dark ? .white.opacity(0.05) : .white.opacity(0.12))
    }
}
