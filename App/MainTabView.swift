import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var tabRouter: TabRouter
    
    var body: some View {
        TabView(selection: $tabRouter.selectedTab) {
            BreathingView()
                .tabItem {
                    Label("Breathe", systemImage: "lungs.fill")
                }
                .tag(0)
            
            ProgressView()
                .tabItem {
                    Label("Insights", systemImage: "chart.xyaxis.line")
                }
                .tag(1)
            
            CheckInView()
                .tabItem {
                    Label("Pledge", systemImage: "signature")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
        // Modern TabView style that adapts to sidebar on iPad
        .tabViewStyle(.sidebarAdaptable)
        // Ensure the global accent and tint is Teal for Liquid Glass transparency compatibility
        .accentColor(.teal)
        .tint(.teal)
    }
}
