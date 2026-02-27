import SwiftUI

final class ThemeManager: ObservableObject {
    // Default value is true, meaning the app starts in Dark Mode on fresh installs.
    @AppStorage("isDarkMode") var isDarkMode: Bool = true
    
    var preferredColorScheme: ColorScheme {
        isDarkMode ? .dark : .light
    }
}
