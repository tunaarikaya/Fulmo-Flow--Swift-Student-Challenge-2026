import SwiftUI

struct MicPermissionAlertOverlay: View {
    @Environment(\.colorScheme) private var colorScheme
    var onCancel: () -> Void
    var onSettings: () -> Void
    
    var body: some View {
        ZStack {
            // Blurred background layer blocking touches
            Color.black.opacity(colorScheme == .dark ? 0.7 : 0.45)
                .ignoresSafeArea()
                .backdropBlur()
                
            VStack(spacing: 24) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.15))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "mic.slash.fill")
                        .font(.system(.title, weight: .bold))
                        .foregroundColor(.orange)
                }
                
                VStack(spacing: 8) {
                    Text("Microphone Required")
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("To analyze your airflow accurately without sending data to the cloud, PulmoFlow needs Microphone access.")
                        .font(.system(.body, design: .rounded, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
                VStack(spacing: 12) {
                    Button(action: onSettings) {
                        Text("Open Settings")
                            .font(.system(.headline, design: .rounded, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.orange)
                            .clipShape(Capsule())
                            .shadow(color: .orange.opacity(0.4), radius: 10, y: 5)
                    }
                    
                    Button(action: onCancel) {
                        Text("Cancel Workout")
                            .font(.system(.headline, design: .rounded, weight: .bold))
                            .foregroundColor(.secondary)
                            .padding(.vertical, 12)
                    }
                }
                .padding(.top, 10)
                .padding(.horizontal, 16)
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(Color(uiColor: .systemBackground))
                    .shadow(color: .black.opacity(colorScheme == .dark ? 0.4 : 0.15), radius: 30, x: 0, y: 15)
            )
            .frame(maxWidth: 340)
        }
        .zIndex(999) // Ensures it sits above everything
    }
}

// Minimal Blur fallback modifier. Swift Playgrounds provides .ultraThinMaterial and similar options.
extension View {
    func backdropBlur() -> some View {
        self.background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
        )
    }
}
