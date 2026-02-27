import SwiftUI

// MARK: - Exercise Card (Grid Item)
struct ExerciseCard: View {
    let exercise: BreathingExercise
    var namespace: Namespace.ID
    /// When false (e.g. this card's detail is open), skip matchedGeometryEffect so the card doesn't expand behind the popup.
    var useMatchedGeometry: Bool = true
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    @Environment(\.colorScheme) private var colorScheme
    
    private var cardFillColor: Color {
        if colorScheme == .dark { return .clear }
        return Color(red: 0.86, green: 0.90, blue: 0.93).opacity(0.9)
    }
    
    private var outerBorderColor: Color {
        colorScheme == .dark ? .white.opacity(0.2) : .black.opacity(0.14)
    }
    
    private var innerBorderColor: Color {
        colorScheme == .dark ? .white.opacity(0.06) : .white.opacity(0.35)
    }
    
    private var cardShadowColor: Color {
        colorScheme == .dark ? .black.opacity(0.12) : .black.opacity(0.08)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: exercise.icon)
                .font(.system(.title, weight: .bold)) // Dynamic Type
                .foregroundColor(exercise.color)
                .conditionalMatchedGeometry(id: "icon_\(exercise.id)", namespace: namespace, use: useMatchedGeometry, isSource: true)
                .frame(width: 60, height: 60)
                .background(exercise.color.opacity(colorScheme == .dark ? 0.12 : 0.18))
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .conditionalMatchedGeometry(id: "icon_bg_\(exercise.id)", namespace: namespace, use: useMatchedGeometry, isSource: true)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.rawValue)
                    .font(.system(.title3, design: .rounded, weight: .bold)) // Dynamic Type
                    .foregroundColor(.primary)
                    .conditionalMatchedGeometry(id: "title_\(exercise.id)", namespace: namespace, use: useMatchedGeometry, isSource: true)
                
                Text(exercise.subtitle)
                    .font(.system(.subheadline, design: .rounded, weight: .medium)) // Dynamic Type
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .conditionalMatchedGeometry(id: "subtitle_\(exercise.id)", namespace: namespace, use: useMatchedGeometry, isSource: true)
            }
        }
        .accessibilityElement(children: .ignore) // Create a single VoiceOver interaction element
        .accessibilityLabel(exercise == .rescue ? "Emergency Protocol. \(exercise.rawValue). \(exercise.subtitle)" : "\(exercise.rawValue). \(exercise.subtitle)")
        .accessibilityAddTraits(.isButton)
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 180)
        .background {
            ZStack {
                if reduceTransparency {
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(Color(.secondarySystemBackground))
                } else {
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(colorScheme == .dark ? AnyShapeStyle(.ultraThinMaterial) : AnyShapeStyle(cardFillColor))
                        .opacity(colorScheme == .dark ? 0.6 : 1)
                }
            }
            .conditionalMatchedGeometry(id: "bg_\(exercise.id)", namespace: namespace, use: useMatchedGeometry, isSource: true)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .stroke(outerBorderColor, lineWidth: colorScheme == .dark ? 1 : 1.2)
                .conditionalMatchedGeometry(id: "border_\(exercise.id)", namespace: namespace, use: useMatchedGeometry, isSource: true)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .inset(by: 1.5)
                .stroke(innerBorderColor, lineWidth: 1)
        )
        .shadow(color: cardShadowColor, radius: colorScheme == .dark ? 16 : 12, x: 0, y: 6)
        .overlay(alignment: .topTrailing) {
            if exercise == .rescue {
                HStack(spacing: 4) {
                    Image(systemName: "cross.circle.fill")
                        .font(.system(.caption2, weight: .bold))
                    Text("EMERGENCY")
                        .font(.system(.caption2, design: .rounded, weight: .bold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.red.opacity(0.9))
                .clipShape(Capsule())
                .shadow(color: .red.opacity(0.4), radius: 8, y: 4)
                .offset(x: -20, y: 20)
            }
        }
        .contentShape(Rectangle())
    }
}

// Helper: apply matchedGeometryEffect only when needed so the grid card doesn't expand when popup is open.
extension View {
    @ViewBuilder
    func conditionalMatchedGeometry(id: String, namespace: Namespace.ID, use: Bool, isSource: Bool) -> some View {
        if use {
            self.matchedGeometryEffect(id: id, in: namespace, isSource: isSource)
        } else {
            self
        }
    }
}
