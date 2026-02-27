import SwiftUI

public struct CheckInDayHeader: View {
    let date: Date
    private let calendar = Calendar.current
    
    public init(date: Date) {
        self.date = date
    }
    
    public var body: some View {
        HStack(spacing: 10) {
            Text(date.formatted(.dateTime.weekday(.wide).day().month(.wide)))
                .font(.system(.headline, design: .rounded, weight: .semibold))
                .foregroundStyle(.primary)
            
            if calendar.isDateInToday(date) {
                Text("Today")
                    .font(.system(.caption, design: .rounded, weight: .semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(.teal.opacity(0.2))
                    .foregroundStyle(.teal)
                    .clipShape(Capsule())
            }
            
            Spacer()
        }
    }
}
