import SwiftUI
import CoreHaptics

@MainActor
final class HapticManager {
    static let shared = HapticManager()
    private init() {}

    /// Trigger a simple impact feedback if haptics are enabled in Settings
    func playImpact(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        // Checking the user's preference from UserDefaults
        let hapticsEnabled = UserDefaults.standard.object(forKey: "isHapticsEnabled") as? Bool ?? true
        guard hapticsEnabled else { return }

        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }

    /// Trigger notification feedback (e.g., success, warning, error)
    func playNotification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let hapticsEnabled = UserDefaults.standard.object(forKey: "isHapticsEnabled") as? Bool ?? true
        guard hapticsEnabled else { return }

        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}
