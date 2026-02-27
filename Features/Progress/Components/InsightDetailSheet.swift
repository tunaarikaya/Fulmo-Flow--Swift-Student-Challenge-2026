import SwiftUI

struct OfflineInsight: Identifiable {
    let id = UUID()
    let title: String
    let metricValue: String
    let unit: String
    let symbol: String
    let color: Color
    let insightText: String
    let systemExplanation: String
}

struct InsightPopupCard: View {
    let insight: OfflineInsight
    let onClose: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    
    var body: some View {
        VStack(spacing: 32) {
            // Header Metric Icon
            ZStack {
                Circle()
                    .fill(insight.color.opacity(colorScheme == .dark ? 0.2 : 0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: insight.symbol)
                    .font(.system(.title, weight: .semibold))
                    .foregroundStyle(insight.color)
            }
            .padding(.top, 8)
            .accessibilityHidden(true)
            
            // Metric Title & Value
            VStack(spacing: 8) {
                Text(insight.title)
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(.secondary)
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(insight.metricValue)
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundStyle(.primary)
                    
                    Text(insight.unit)
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .foregroundStyle(.secondary)
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(insight.title) is \(insight.metricValue) \(insight.unit)")
            
            // AI Generated Insight Panel
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: "cpu")
                        .font(.subheadline)
                        .foregroundStyle(insight.color)
                    Text("ON-DEVICE ALGORITHM")
                        .font(.system(.subheadline, design: .rounded, weight: .bold))
                        .foregroundStyle(insight.color)
                }
                
                Text(insight.insightText)
                    .font(.system(.body, design: .rounded, weight: .medium))
                    .foregroundStyle(.primary)
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
                
                Divider()
                    .padding(.vertical, 8)
                
                Text(insight.systemExplanation)
                    .font(.system(.subheadline, design: .rounded, weight: .regular))
                    .foregroundStyle(.secondary)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(24)
            .insightPanel(tint: insight.color.opacity(0.1))
            
            Button(action: onClose) {
                Text("Close")
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(insight.color)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .padding(.top, 8)
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 36, style: .continuous)
                .fill(reduceTransparency ? AnyShapeStyle(Color(uiColor: .systemBackground)) : AnyShapeStyle(.ultraThinMaterial))
                .shadow(color: .black.opacity(0.2), radius: 40, x: 0, y: 15)
        )
        .padding(24)
    }
}
