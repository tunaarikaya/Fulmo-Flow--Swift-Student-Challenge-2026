import SwiftUI
import AVFoundation

struct SettingsPreferencesSection: View {
    @Bindable var viewModel: SettingsViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("App Preferences")

            VStack(spacing: 0) {
                // Dark Mode toggle
                HStack(spacing: 14) {
                    iconBox("moon.fill", color: .indigo)
                    Text("Dark Mode")
                        .font(.system(.headline, design: .rounded, weight: .medium))
                        .foregroundStyle(.primary)
                    Spacer()
                    Toggle("Dark Mode", isOn: $themeManager.isDarkMode)
                        .tint(.teal)
                        .labelsHidden()
                        .accessibilityLabel("Toggle Dark Mode")
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 14)
                
                cardDivider
                
                // Haptics toggle
                HStack(spacing: 14) {
                    iconBox("hand.tap.fill", color: .pink)
                    Text("Haptic Feedback")
                        .font(.system(.headline, design: .rounded, weight: .medium))
                        .foregroundStyle(.primary)
                    Spacer()
                    Toggle("Haptic Feedback", isOn: $viewModel.isHapticsEnabled)
                        .tint(.teal)
                        .labelsHidden()
                        .accessibilityLabel("Toggle Haptic Feedback")
                        .onChange(of: viewModel.isHapticsEnabled) { _, newValue in
                            if newValue {
                                HapticManager.shared.playImpact(style: .medium)
                            }
                        }
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 14)

                cardDivider
                
                // Microphone Access (Sleek Apple Setup)
                HStack(spacing: 14) {
                    iconBox(viewModel.isMicrophoneEnabled ? "mic.fill" : "mic.slash.fill", color: .orange)
                    Text("Microphone Analysis")
                        .font(.system(.headline, design: .rounded, weight: .medium))
                        .foregroundStyle(.primary)
                    Spacer()
                    Toggle("Microphone Analysis", isOn: $viewModel.isMicrophoneEnabled)
                        .tint(.teal)
                        .labelsHidden()
                        .accessibilityLabel("Toggle Microphone Analysis")
                        .onChange(of: viewModel.isMicrophoneEnabled) { _, newValue in
                            if newValue {
                                // If they toggle it ON but iOS system denied it previously, we bounce them to OS Settings!
                                let perm = AVAudioApplication.shared.recordPermission
                                if perm == .denied {
                                    if let url = URL(string: UIApplication.openSettingsURLString) {
                                        UIApplication.shared.open(url)
                                    }
                                } else if perm == .undetermined {
                                    // Let the OS ask natively
                                    AVAudioApplication.requestRecordPermission { _ in }
                                }
                            }
                        }
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 14)

                cardDivider

                // Companion Mode
                HStack(spacing: 14) {
                    iconBox(viewModel.selectedMode.icon, color: viewModel.selectedMode.color)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Companion Mode")
                            .font(.system(.headline, design: .rounded, weight: .medium))
                            .foregroundStyle(.primary)
                        Text(viewModel.selectedMode.rawValue)
                            .font(.system(.footnote, design: .rounded))
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Menu {
                        Picker("Mode", selection: $viewModel.selectedMode) {
                            ForEach(CompanionMode.allCases) { mode in
                                Text(mode.rawValue).tag(mode)
                            }
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text("Change")
                                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            Image(systemName: "chevron.up.chevron.down")
                                .font(.system(.caption2, weight: .semibold))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(viewModel.selectedMode.color.opacity(colorScheme == .dark ? 0.18 : 0.1))
                        .clipShape(Capsule())
                        .foregroundStyle(viewModel.selectedMode.color)
                    }
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 14)
            }
            .settingsCard()
        }
    }
    
    // MARK: - Reusable Helpers

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(.title3, design: .rounded, weight: .bold))
            .foregroundStyle(.primary)
            .padding(.horizontal, 2)
    }

    private var cardDivider: some View {
        Rectangle()
            .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.06))
            .frame(height: 1)
            .padding(.leading, 60)
    }

    private func iconBox(_ name: String, color: Color) -> some View {
        Image(systemName: name)
            .font(.system(.subheadline, weight: .medium))
            .foregroundStyle(color)
            .frame(width: 32, height: 32)
            .background(color.opacity(colorScheme == .dark ? 0.18 : 0.12))
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
