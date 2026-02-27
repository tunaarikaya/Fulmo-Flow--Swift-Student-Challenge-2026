import SwiftUI

// MARK: - Detailed Overlay (Pop-Over)
struct ExerciseDetailOverlay: View {
    let exercise: BreathingExercise
    var namespace: Namespace.ID
    var onDismiss: () -> Void
    var onStart: () -> Void
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            // Main Card (no dimmed background — popup only)
            VStack(alignment: .leading, spacing: 24) {
                // Header (Matched)
                HStack(alignment: .center, spacing: 20) {
                    Image(systemName: exercise.icon)
                        .font(.system(.title, weight: .bold))
                        .foregroundColor(exercise.color)
                        .matchedGeometryEffect(id: "icon_\(exercise.id)", in: namespace, isSource: false)
                        .frame(width: 80, height: 80)
                        .background(exercise.color.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .matchedGeometryEffect(id: "icon_bg_\(exercise.id)", in: namespace, isSource: false)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        if exercise == .rescue {
                            Text("EMERGENCY PROTOCOL")
                                .font(.system(.caption2, design: .rounded, weight: .black))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.red.opacity(0.85))
                                .clipShape(Capsule())
                        }
                        
                        Text(exercise.rawValue)
                            .font(.system(.title, design: .rounded, weight: .bold))
                            .foregroundColor(.primary)
                            .matchedGeometryEffect(id: "title_\(exercise.id)", in: namespace, isSource: false)
                        
                        Text(exercise.subtitle)
                            .font(.system(.body, design: .rounded, weight: .medium))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .matchedGeometryEffect(id: "subtitle_\(exercise.id)", in: namespace, isSource: false)
                    }
                    
                    Spacer()
                    
                    Button(action: onDismiss) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(.largeTitle))
                            .foregroundColor(.secondary)
                    }
                    .accessibilityLabel("Close Detail")
                }

                // Purpose Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("PURPOSE")
                        .font(.system(.footnote, design: .rounded, weight: .black))
                        .foregroundColor(exercise.color)
                    
                    Text(exercise.medicalBenefit)
                        .font(.system(.body, design: .rounded, weight: .medium))
                        .foregroundColor(.primary.opacity(0.9))
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(exercise.color.opacity(colorScheme == .dark ? 0.15 : 0.08))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .transition(.move(edge: .bottom).combined(with: .opacity))
                
                // Instructions Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("HOW TO DO IT")
                        .font(.system(.footnote, design: .rounded, weight: .black))
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(Array(exercise.instructions.enumerated()), id: \.offset) { index, step in
                            HStack(alignment: .top, spacing: 14) {
                                Text("\(index + 1)")
                                    .font(.system(.callout, design: .rounded, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 32, height: 32)
                                    .background(exercise.color)
                                    .clipShape(Circle())
                                
                                Text(step)
                                    .font(.system(.body, design: .rounded, weight: .medium))
                                    .foregroundColor(.primary)
                                    .lineSpacing(2)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.top, 4)
                            }
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel("Step \(index + 1): \(step)")
                        }
                    }
                }
                .padding(.top, 4)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                
                Spacer()
                
                // Floating Start Button
                Button(action: onStart) {
                    Text("Start Session")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(exercise.color)
                        .clipShape(Capsule())
                        .shadow(color: exercise.color.opacity(0.4), radius: 10, x: 0, y: 5)
                }
            }
            .padding(32)
            .background {
                // Solid, readable background (no glass) so tutorial content is clear
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
                    .matchedGeometryEffect(id: "bg_\(exercise.id)", in: namespace, isSource: false)
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(exercise.color.opacity(0.08))
                    .allowsHitTesting(false)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .stroke(exercise.color.opacity(0.35), lineWidth: 1.5)
                    .matchedGeometryEffect(id: "border_\(exercise.id)", in: namespace, isSource: false)
            )
            .frame(width: 520, height: 640)
            .shadow(color: .black.opacity(colorScheme == .dark ? 0.35 : 0.18), radius: 40, x: 0, y: 20)
        }
    }
}
