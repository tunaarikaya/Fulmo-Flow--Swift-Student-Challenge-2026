import SwiftUI

struct CompanionModeGridCard: View {
    let mode: CompanionMode
    let isSelected: Bool
    let action: () -> Void

    private var isPad: Bool { UIDevice.current.userInterfaceIdiom == .pad }

    var body: some View {
        Button(action: action) {
            VStack(spacing: isPad ? 16 : 12) {
                Image(systemName: mode.icon)
                    .font(.system(isPad ? .title2 : .title3, weight: .bold))
                    .foregroundColor(isSelected ? .white : mode.color)
                    .frame(width: isPad ? 64 : 50, height: isPad ? 64 : 50)
                    .background(isSelected ? mode.color : mode.color.opacity(0.12))
                    .clipShape(Circle())
                    .shadow(color: isSelected ? mode.color.opacity(0.4) : .clear, radius: 10)

                VStack(spacing: 2) {
                    Text(mode.rawValue)
                        .font(.system(isPad ? .title3 : .subheadline, design: .rounded, weight: .bold))
                        .foregroundColor(.primary)

                    Text(mode.description)
                        .font(.system(isPad ? .body : .caption2, design: .rounded, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, isPad ? 24 : 16)
            .padding(.horizontal, isPad ? 16 : 10)
            .liquidGlass(
                tint: isSelected ? mode.color : .clear,
                opacity: isSelected ? 0.12 : 0.05
            )
            .overlay(
                RoundedRectangle(cornerRadius: 32)
                    .stroke(isSelected ? mode.color.opacity(0.5) : .clear, lineWidth: 2)
            )
            .overlay(alignment: .topTrailing) {
                if mode == .motivating {
                    Image(systemName: "star.fill")
                        .font(.system(.caption, weight: .black))
                        .foregroundColor(.white)
                        .frame(width: 28, height: 28)
                        .background(LinearGradient(colors: [.yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .clipShape(Circle())
                        .offset(x: 8, y: -8)
                        .shadow(color: .orange.opacity(0.5), radius: 6, y: 3)
                }
            }
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
            .accessibilityLabel("\(mode.rawValue) Mode. \(mode.description)")
        }
        .buttonStyle(.plain)
    }
}
