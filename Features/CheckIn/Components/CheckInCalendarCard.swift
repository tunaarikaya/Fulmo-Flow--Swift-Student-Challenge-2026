import SwiftUI

public struct CheckInCalendarCard: View {
    @ObservedObject var viewModel: CheckInViewModel
    @Binding var displayedMonth: Date // Maintained for protocol compatibility, but mostly unused in strip view
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    
    @State private var showDatePicker = false
    
    private let calendar = Calendar.current
    
    public init(viewModel: CheckInViewModel, displayedMonth: Binding<Date>) {
        self.viewModel = viewModel
        self._displayedMonth = displayedMonth
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            // Header: Month Title and Expand Button
            HStack {
                Text(viewModel.selectedDate.formatted(.dateTime.month(.wide).year()))
                    .font(.system(.headline, design: .rounded, weight: .bold))
                
                Spacer()
                
                Button {
                    showDatePicker.toggle()
                } label: {
                    Image(systemName: "calendar")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.teal)
                        .padding(8)
                        .background(.teal.opacity(0.1))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                .overlay(alignment: .topTrailing) {
                    if showDatePicker {
                        DatePicker(
                            "",
                            selection: Binding(
                                get: { viewModel.selectedDate },
                                set: { newValue in
                                    viewModel.selectDate(newValue)
                                    showDatePicker = false
                                }
                            ),
                            displayedComponents: .date
                        )
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .blendMode(.destinationOver) // Visually hide but keep tappable area if needed, or rely on popover behavior
                        // Alternatively, SwiftUI DatePicker compact style pops over automatically.
                        // We place it over the button invisibly to trigger it, or just use it normally. 
                        // To ensure it works perfectly on iPad/iOS, embedding it directly is safest:
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            // Call to Action for Narrative Engineering Example
            if !(calendar.component(.month, from: viewModel.selectedDate) == 3 && calendar.component(.day, from: viewModel.selectedDate) == 2) {
                HStack(spacing: 6) {
                    Image(systemName: "hand.tap.fill")
                        .font(.system(.caption))
                    Text("Tap March 2nd to see an example pledge")
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                }
                .foregroundStyle(.teal)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color.teal.opacity(0.15))
                .clipShape(Capsule())
                .padding(.bottom, 4)
            }
            
            // Horizontal 7-Day Strip
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(weekDays, id: \.self) { date in
                            Button {
                                viewModel.selectDate(date)
                            } label: {
                                dayCell(for: date)
                            }
                            .buttonStyle(.plain)
                            .id(calendar.startOfDay(for: date))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                }
                .onAppear {
                    proxy.scrollTo(calendar.startOfDay(for: viewModel.selectedDate), anchor: .center)
                }
                .onChange(of: viewModel.selectedDate) { _, newDate in
                    withAnimation {
                        proxy.scrollTo(calendar.startOfDay(for: newDate), anchor: .center)
                    }
                }
            }
        }
        .background(calendarBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(colorScheme == .dark ? .white.opacity(0.14) : .black.opacity(0.12), lineWidth: 1.1)
        )
        .shadow(color: .black.opacity(colorScheme == .dark ? 0.1 : 0.07), radius: 14, x: 0, y: 6)
    }
    
    private func dayCell(for date: Date) -> some View {
        let isSelected = calendar.isDate(date, inSameDayAs: viewModel.selectedDate)
        let isToday = calendar.isDateInToday(date)
        let hasEntry = viewModel.hasEntry(on: date)
        
        // Check if it's the target Narrative Engineering date (March 2nd)
        let isTargetDate = calendar.component(.month, from: date) == 3 && calendar.component(.day, from: date) == 2
        
        return VStack(spacing: 8) {
            Text(date.formatted(.dateTime.weekday(.short)))
                .font(.system(.subheadline, design: .rounded, weight: .bold))
                .foregroundStyle(isSelected ? .teal : .secondary)
            
            Text(date.formatted(.dateTime.day()))
                .font(.system(.title3, design: .rounded, weight: isSelected || isTargetDate ? .bold : .semibold))
                .foregroundStyle(isSelected ? .white : (isTargetDate ? .teal : .primary))
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(isSelected ? .teal : .clear)
                        .overlay(
                            Circle()
                                .stroke(isTargetDate && !isSelected ? .teal.opacity(0.8) : (isToday && !isSelected ? .teal.opacity(0.5) : .clear), lineWidth: isTargetDate ? 2 : 1.5)
                        )
                )
            
            Circle()
                .fill(hasEntry ? .teal.opacity(0.9) : .clear)
                .frame(width: 4, height: 4)
        }
        .frame(width: 52)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(date.formatted(.dateTime.weekday(.wide).month(.wide).day()))
        .accessibilityValue(hasEntry ? "Has entry" : "No entry")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityAddTraits(isToday ? .isButton : [])
    }
    
    // MARK: - Helpers
    private var calendarBackground: some ShapeStyle {
        if reduceTransparency {
            return AnyShapeStyle(Color(uiColor: .secondarySystemGroupedBackground))
        }
        if colorScheme == .dark {
            return AnyShapeStyle(.ultraThinMaterial)
        }
        return AnyShapeStyle(Color(red: 0.84, green: 0.88, blue: 0.92).opacity(0.88))
    }
    
    // Generate an array of dates: 14 days in the past + 14 days in the future relative to today
    private var weekDays: [Date] {
        let today = calendar.startOfDay(for: .now)
        var days: [Date] = []
        for offset in -14...14 {
            if let date = calendar.date(byAdding: .day, value: offset, to: today) {
                days.append(date)
            }
        }
        return days
    }
}
