import SwiftUI

@main
struct PulmoFlowApp: App {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var tabRouter = TabRouter()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    MainTabView()
                        .transition(.opacity)
                } else {
                    OnboardingView()
                        .transition(.opacity)
                }
            }
            .preferredColorScheme(themeManager.preferredColorScheme)
            .environment(\.colorScheme, themeManager.preferredColorScheme)
            .environmentObject(themeManager)
            .environmentObject(tabRouter)
        }
    }
}
