import SwiftUI

final class TabRouter: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var checkInTargetDate: Date? = nil
    
    // Tab indices: 0 = Breathe, 1 = Insights, 2 = Check-In, 3 = Settings
    func navigateTo(tab: Int, targetDate: Date? = nil) {
        if let targetDate {
            checkInTargetDate = targetDate
        }
        selectedTab = tab
    }
}
