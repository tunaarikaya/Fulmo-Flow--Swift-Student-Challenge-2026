import SwiftUI

public struct PaperKitInfoSheet: View {
    public var onDismiss: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    
    public init(onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header Section
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.teal.opacity(colorScheme == .dark ? 0.15 : 0.1))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "signature")
                        .font(.system(.title, weight: .bold))
                        .foregroundColor(.teal)
                }
                .padding(.top, 40)
                
                VStack(spacing: 8) {
                    Text("Daily Pledge")
                        .font(.system(.caption, design: .rounded, weight: .black))
                        .foregroundColor(.teal)
                    
                    Text("Seal Your Effort")
                        .font(.system(.title, design: .rounded, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("This is your commitment canvas.")
                        .font(.system(.body, design: .rounded, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 24)
            
            Spacer(minLength: 40)
            
            // Info Card Section
            VStack(alignment: .leading, spacing: 12) {
                Text("WHY THIS MATTERS")
                    .font(.system(.caption, design: .rounded, weight: .black))
                    .foregroundColor(.teal)
                
                Text("Building a habit requires intention. Powered by **Apple's native PencilKit & PaperKit frameworks**, this space lets you physically sign your day using touch or an Apple Pencil with ultra-low latency. Add a memorable photo to remind yourself of who you are fighting for.")
                    .font(.system(.callout, design: .rounded, weight: .medium))
                    .foregroundColor(.primary.opacity(0.9))
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.teal.opacity(colorScheme == .dark ? 0.15 : 0.08))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding(.horizontal, 24)
            
            Spacer(minLength: 40)
            
            // Action Section
            VStack(spacing: 24) {
                Button(action: {
                    onDismiss()
                }) {
                    Text("I Understand")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(Color.teal)
                        .clipShape(Capsule())
                        .shadow(color: .teal.opacity(0.3), radius: 10, x: 0, y: 5)
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .frame(width: 520, height: 600)
        .background {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(colorScheme == .dark ? 0.35 : 0.18), radius: 40, x: 0, y: 20)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .stroke(Color.teal.opacity(0.35), lineWidth: 1.5)
        )
    }
}
