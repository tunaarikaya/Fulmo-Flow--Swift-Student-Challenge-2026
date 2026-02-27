import SwiftUI

struct SettingsView: View {
    @State private var viewModel = SettingsViewModel()
    @State private var showingEditProfile = false
    @State private var showingDedication = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                SettingsProfileHeroCard(
                    viewModel: viewModel,
                    showingEditProfile: $showingEditProfile
                )
                
                SettingsDedicationRow(
                    showingDedication: $showingDedication
                )
                
                SettingsClinicalExportSection(
                    viewModel: viewModel
                )
                
                SettingsPreferencesSection(
                    viewModel: viewModel
                )
                
                SettingsPrivacySection()

                Text("PulmoFlow")
                    .font(.system(.footnote, design: .rounded, weight: .medium))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 12)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
        .background(MeshGradientBackground())
        .navigationTitle("Settings")
        .sheet(isPresented: $showingEditProfile) {
            SettingsEditProfileSheet(viewModel: viewModel)
        }
        .fullScreenCover(isPresented: $showingDedication) {
            DedemDedicationView()
        }
    }
}

#Preview {
    NavigationStack { SettingsView() }
        .environmentObject(ThemeManager())
}
