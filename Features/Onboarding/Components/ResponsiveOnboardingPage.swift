import SwiftUI

struct ResponsiveOnboardingPage<Content: View>: View {
    @ViewBuilder let content: Content
    private var isPad: Bool { UIDevice.current.userInterfaceIdiom == .pad }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack {
                    Spacer(minLength: isPad ? 80 : 40)
                    content
                        .frame(maxWidth: isPad ? 800 : 650)
                    Spacer(minLength: isPad ? 180 : 140)
                }
                .frame(minHeight: geometry.size.height)
                .frame(maxWidth: .infinity)
            }
        }
    }
}
