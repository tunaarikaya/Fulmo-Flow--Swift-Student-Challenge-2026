import SwiftUI

struct SettingsPrivacySection: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var isAnimating = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "lock.shield.fill")
                .font(.system(.title))
                .foregroundStyle(.green.gradient)
                .symbolEffect(.pulse, options: .repeating, isActive: isAnimating && !reduceMotion)
            
            VStack(spacing: 8) {
                Text("100% Offline & Private")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(.primary)
                
                Text("PulmoFlow does not use the internet. All acoustic algorithms, measurements, and personalized tracking run locally on your iPad. Your personal health data never leaves this device.")
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(32)
        .background {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
                .overlay {
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .stroke(Color.green.opacity(0.3), lineWidth: 1)
                }
                .shadow(color: .green.opacity(0.1), radius: 20)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Privacy and Security Shield. Zero Cloud Connectivity. All analysis runs locally.")
        .onAppear {
            isAnimating = true
        }
    }
}
