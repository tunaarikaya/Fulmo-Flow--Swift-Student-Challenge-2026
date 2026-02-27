import SwiftUI

struct AnalysisHistoryView: View {
    let samples: [VitalSample]
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background exactly as the rest of the app
                MeshGradientBackground()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Header Intro
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Clinical Data Archive")
                                .font(.system(.largeTitle, design: .rounded, weight: .bold)) // changed to bold
                            Text("A comprehensive record of your pulmonary health trends over the past week, captured locally.")
                                .font(.system(.title3, design: .rounded, weight: .regular))
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 40)
                        .padding(.top, 40)
                        
                        // Records Grid/List
                        VStack(spacing: 24) {
                            ForEach(samples.sorted(by: { $0.date > $1.date })) { sample in
                                AnalysisRow(sample: sample)
                            }
                        }
                        .padding(40)
                    }
                }
            }
            .navigationTitle("Analysis Results")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(.largeTitle))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.secondary)
                    }
                    .accessibilityLabel("Close Archive")
                }
            }
        }
    }
}

#Preview {
    AnalysisHistoryView(samples: HealthSimulator.shared.weeklyData)
}
