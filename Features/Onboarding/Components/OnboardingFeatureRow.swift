import SwiftUI

struct OnboardingFeatureRow: View {
    let icon: String
    let title: String
    let subtext: String

    private var isPad: Bool { UIDevice.current.userInterfaceIdiom == .pad }

    var body: some View {
        HStack(spacing: isPad ? 20 : 16) {
            Image(systemName: icon)
                .font(.system(isPad ? .title2 : .title3, weight: .semibold))
                .foregroundStyle(.teal)
                .frame(width: isPad ? 44 : 36, height: isPad ? 44 : 36)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(isPad ? .title3 : .body, design: .rounded, weight: .bold))
                    .foregroundStyle(.primary)

                Text(subtext)
                    .font(.system(isPad ? .body : .caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .lineSpacing(2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(subtext)")
    }
}
