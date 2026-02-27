import SwiftUI
import Charts

struct RespiratoryTrendChart: View {
    let weeklyData: [VitalSample]
    let onTap: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button {
            onTap()
        } label: {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Respiratory Trend")
                        .font(.system(.title2, design: .rounded, weight: .semibold))
                    
                    Text("PULSATION (BPM)")
                        .font(.system(.caption, design: .rounded, weight: .bold))
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 8)
                
                Chart {
                    ForEach(weeklyData) { sample in
                        LineMark(
                            x: .value("Day", sample.date, unit: .day),
                            y: .value("RR", sample.respiratoryRate)
                        )
                        .foregroundStyle(.cyan.gradient)
                        .lineStyle(StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                        .symbol {
                            Circle()
                                .strokeBorder(Color.cyan, lineWidth: 2)
                                .background(Circle().fill(Color.black.opacity(colorScheme == .dark ? 0.8 : 0.1)))
                                .frame(width: 8, height: 8)
                        }
                    }
                }
                .frame(height: 250)
                .chartYScale(domain: 12...24)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { _ in
                        AxisGridLine(stroke: StrokeStyle(dash: [2, 4]))
                            .foregroundStyle(colorScheme == .dark ? .white.opacity(0.1) : .black.opacity(0.12))
                        AxisValueLabel(anchor: .top)
                            .foregroundStyle(.secondary)
                            .font(.system(.caption, design: .rounded, weight: .semibold))
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading, values: .automatic(desiredCount: 4)) { _ in
                        AxisGridLine()
                            .foregroundStyle(colorScheme == .dark ? .white.opacity(0.1) : .black.opacity(0.12))
                        AxisValueLabel()
                            .foregroundStyle(.secondary)
                            .font(.system(.caption, design: .rounded, weight: .medium))
                    }
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(32)
        .insightPanel(tint: colorScheme == .dark ? .white.opacity(0.05) : .white.opacity(0.18))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Respiratory Trend Chart spanning 1 week. Tap to view detailed analysis.")
        .accessibilityAddTraits(.isButton)
    }
}
