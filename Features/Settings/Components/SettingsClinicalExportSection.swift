import SwiftUI

struct SettingsClinicalExportSection: View {
    @Bindable var viewModel: SettingsViewModel
    @Environment(\.colorScheme) private var colorScheme
    
    // We optionally hold the URL to be shared
    @State private var exportURL: URL?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Clinical Export")
                .font(.system(.title3, design: .rounded, weight: .bold))
                .foregroundStyle(.primary)
                .padding(.horizontal, 2)
            
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 16) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(.title2))
                        .foregroundStyle(.teal)
                        .frame(width: 48, height: 48)
                        .background(.teal.opacity(colorScheme == .dark ? 0.2 : 0.15))
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Export Health Report")
                            .font(.system(.headline, design: .rounded, weight: .bold))
                            .foregroundStyle(.primary)
                        
                        Text("Generate a structured JSON report of your weekly respiratory and pulsation data for your pulmonologist.")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(.secondary)
                            .lineSpacing(2)
                    }
                }
                
                if let url = exportURL {
                    ShareLink(item: url) {
                        HStack {
                            Spacer()
                            Text("Share Report")
                                .font(.system(.headline, design: .rounded, weight: .bold))
                            Image(systemName: "square.and.arrow.up")
                                .font(.headline)
                            Spacer()
                        }
                        .padding(.vertical, 14)
                        .background(.teal)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .accessibilityLabel("Share JSON Health Report")
                } else {
                    Button {
                        // Generate URL on demand
                        exportURL = viewModel.generateClinicalReportURL()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Generate Clinical Artifact")
                                .font(.system(.headline, design: .rounded, weight: .bold))
                            Image(systemName: "arrow.counterclockwise")
                                .font(.headline)
                            Spacer()
                        }
                        .padding(.vertical, 14)
                        .background(.teal.opacity(0.15))
                        .foregroundStyle(.teal)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                }
            }
            .padding(20)
            .settingsCard()
        }
        .onAppear {
            // Pre-generate URL if possible
            exportURL = viewModel.generateClinicalReportURL()
        }
    }
}
