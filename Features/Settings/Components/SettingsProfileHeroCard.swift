import SwiftUI

struct SettingsProfileHeroCard: View {
    @Bindable var viewModel: SettingsViewModel
    @Binding var showingEditProfile: Bool
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 18) {
                // Profile Image with fallback to system icon
                ZStack {
                    Circle()
                        .fill(Color.teal.opacity(colorScheme == .dark ? 0.2 : 0.12))
                        .frame(width: 80, height: 80)

                    if let data = viewModel.profileImageData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 72, height: 72)
                            .foregroundStyle(
                                colorScheme == .dark ? Color.white : Color.teal
                            )
                    }
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text(viewModel.profile.name)
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundStyle(.primary)

                    Text(viewModel.profile.status)
                        .font(.system(.subheadline, design: .rounded, weight: .medium))
                        .foregroundStyle(.teal)
                }

                Spacer()

                Button {
                    showingEditProfile = true
                } label: {
                    Image(systemName: "pencil")
                        .font(.system(.title3, weight: .bold)) // Büyütüldü
                        .foregroundStyle(.teal)
                        .frame(width: 44, height: 44) // Alanı genişletildi
                        .background(Color.teal.opacity(colorScheme == .dark ? 0.18 : 0.12))
                        .clipShape(Circle())
                }
                .accessibilityLabel("Edit Profile")
                .buttonStyle(.plain)
            }

            // Vital badges
            HStack(spacing: 10) {
                vitalBadge(icon: "calendar", label: "Age \(viewModel.profile.age)")
                vitalBadge(icon: "drop.fill", label: viewModel.profile.bloodType)
                vitalBadge(icon: "lungs.fill", label: viewModel.profile.oxygenLevel)
                Spacer()
            }
            .onTapGesture { showingEditProfile = true }
        }
        .padding(24)
        .settingsCard(borderAccent: .teal)
    }

    private func vitalBadge(icon: String, label: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(.caption2, weight: .semibold))
                .foregroundStyle(.teal)
            Text(label)
                .font(.system(.caption, design: .rounded, weight: .semibold))
                .foregroundStyle(.primary)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label)
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .background(Color.teal.opacity(colorScheme == .dark ? 0.14 : 0.08))
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.teal.opacity(colorScheme == .dark ? 0.25 : 0.18), lineWidth: 1))
    }
}
