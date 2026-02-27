import SwiftUI

public struct CheckInHeaderView: View {
    public init() {}
    
    public var body: some View {
        VStack(spacing: 8) {
            Text("Daily Pledge")
                .font(.system(.largeTitle, design: .rounded, weight: .bold)) // Uses HIG Dynamic Type
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Did you complete your breathing exercises today? Sign or leave a mark to seal today's effort. Consistency is your greatest strength.")
                .font(.system(.callout, design: .rounded, weight: .medium)) // Uses HIG Dynamic Type
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(4)
        }
        .padding(.bottom, 8)
    }
}
