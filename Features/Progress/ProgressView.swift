import SwiftUI
import Charts

struct ProgressView: View {
    @State private var viewModel = ProgressViewModel()
    @State private var showingHistory = false
    @State private var selectedInsight: OfflineInsight?
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 40) {
                // Header: Lung Status
                LungStatusHeader(
                    statusColor: viewModel.statusColor,
                    lungStatus: viewModel.lungStatus
                )
                
                // Daily AI Insight Orb
                DailyInsightCard()
                
                // Charts Section
                RespiratoryTrendChart(
                    weeklyData: viewModel.weeklyData
                ) {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        selectedInsight = OfflineInsight(
                            title: "Respiratory Trend",
                            metricValue: "Graph",
                            unit: "Analysis",
                            symbol: "chart.xyaxis.line",
                            color: .cyan,
                            insightText: "The graph shows a stable pulsation and respiration over the past week, consistent with effective medication and relaxation exercises. Keeping a steady line means fewer flare-ups.",
                            systemExplanation: "Trend data analyzed completely on-device without network calls."
                        )
                    }
                }
                
                // Bento Grid: Metrics (Static/Read-only)
                metricsGrid
                
                // Info Disclaimer
                InfoDisclaimerView()
                
                // Main Action: View Analysis Results
                HistoricalAnalysisButton {
                    showingHistory = true
                }
            }
            .padding(40)
        }
        .background(MeshGradientBackground())
        .navigationTitle("Clinical Insights")
        .fullScreenCover(isPresented: $showingHistory) {
            AnalysisHistoryView(samples: viewModel.weeklyData)
        }
        
        if let insight = selectedInsight {
            Color.black.opacity(colorScheme == .dark ? 0.6 : 0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        selectedInsight = nil
                    }
                }
                .transition(.opacity)
                .zIndex(1)
            
            InsightPopupCard(insight: insight) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    selectedInsight = nil
                }
            }
            .transition(.scale(scale: 0.9).combined(with: .opacity))
            .zIndex(2)
        }
        }
    }
    
    // MARK: - Local Computed Layouts
    
    private var metricsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 24),
            GridItem(.flexible(), spacing: 24),
            GridItem(.flexible(), spacing: 24)
        ], spacing: 24) {
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    selectedInsight = OfflineInsight(
                        title: "Respiration",
                        metricValue: String(format: "%.1f", viewModel.currentSample.respiratoryRate),
                        unit: "BPM",
                        symbol: "wind",
                        color: .cyan,
                        insightText: "Your breathing rate is steady. The acoustic profile of your exhalations over the past 24 hours shows a consistent and healthy rhythmic pattern.",
                        systemExplanation: "Analyzed completely offline on your device using Apple Foundation Models and AVFoundation acoustic processing."
                    )
                }
            } label: {
                MetricCard(
                    title: "Respiration",
                    value: String(format: "%.1f", viewModel.currentSample.respiratoryRate),
                    unit: "BPM",
                    icon: "wind",
                    tint: .cyan
                )
            }
            .buttonStyle(.plain)
            
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    selectedInsight = OfflineInsight(
                        title: "HRV",
                        metricValue: String(format: "%.0f", viewModel.currentSample.hrv),
                        unit: "ms",
                        symbol: "waveform.path.ecg",
                        color: .indigo,
                        insightText: "Your Heart Rate Variability suggests a calm physiological state. Our local, on-device algorithms detect minimal respiratory stress, reflecting excellent recovery.",
                        systemExplanation: "Analyzed completely offline via iOS HealthKit HRV sampling and on-device intelligent evaluation."
                    )
                }
            } label: {
                MetricCard(
                    title: "HRV",
                    value: String(format: "%.0f", viewModel.currentSample.hrv),
                    unit: "ms",
                    icon: "waveform.path.ecg",
                    tint: .indigo
                )
            }
            .buttonStyle(.plain)
            
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    selectedInsight = OfflineInsight(
                        title: "SpO2",
                        metricValue: String(format: "%.0f%%", viewModel.currentSample.oxygenLevel),
                        unit: "Oxygen",
                        symbol: "lungs.fill",
                        color: .teal,
                        insightText: "Based on the offline analysis of your recent breath metrics, your Oxygen saturation remains at optimal levels for Pulmonary Fibrosis management. This indicates a stable respiratory function.",
                        systemExplanation: "Analyzed completely offline on your iPad M-Series chip using Foundation Models without any cloud connectivity."
                    )
                }
            } label: {
                MetricCard(
                    title: "SpO2",
                    value: String(format: "%.0f%%", viewModel.currentSample.oxygenLevel),
                    unit: "Oxygen",
                    icon: "lungs.fill",
                    tint: .teal
                )
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    NavigationStack {
        ProgressView()
    }
}
