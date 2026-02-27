import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @State private var currentPage = 0
    @State private var successTrigger = false
    @Namespace private var animationNamespace
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    private var isPad: Bool { UIDevice.current.userInterfaceIdiom == .pad }

    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground).ignoresSafeArea()

            // Global Animated Background for all pages
            AnimatedBackgroundView()

            TabView(selection: $currentPage) {
                // Screen 1: The Entrance (Premium Welcome)
                ResponsiveOnboardingPage {
                    VStack(spacing: isPad ? 60 : 40) {
                        ZStack {
                            // Ambient Glow
                            Circle()
                                .fill(Color.teal.opacity(0.15))
                                .frame(width: isPad ? 320 : 220, height: isPad ? 320 : 220)
                                .blur(radius: 50)
                                .symbolEffect(.pulse, options: .repeating)

                            // Main Icon with Layered Depth
                            Image(systemName: "lungs.fill")
                                .font(.system(size: isPad ? 160 : 100))
                                .imageScale(.large)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.teal, .cyan.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .symbolEffect(.breathe, options: .repeating)
                                .shadow(color: .teal.opacity(0.3), radius: 30, x: 0, y: 15)
                        }

                        VStack(spacing: 16) {
                            Text("PulmoFlow")
                                .font(.system(isPad ? .largeTitle : .title, design: .rounded, weight: .bold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.primary, .primary.opacity(0.8)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )

                            VStack(spacing: 8) {
                                Text("Take a deep breath.")
                                    .font(.system(isPad ? .title : .title3, design: .rounded, weight: .semibold))
                                    .foregroundStyle(.teal)

                                Text("I'm here to help you regain control of your breath.")
                                    .font(.system(isPad ? .title3 : .body, design: .rounded, weight: .medium))
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                                    .lineSpacing(4)
                            }
                        }
                    }
                }
                .tag(0)

                // Screen 2: The Mission
                ResponsiveOnboardingPage {
                    VStack(spacing: isPad ? 40 : 20) {
                        ZStack {
                            Circle()
                                .fill(Color.teal.opacity(0.14))
                                .frame(width: isPad ? 160 : 100, height: isPad ? 160 : 100)
                                .blur(radius: 20)

                            Image(systemName: "lungs.fill")
                                .font(.system(size: isPad ? 80 : 56))
                                .foregroundStyle(
                                    LinearGradient(colors: [.teal, .cyan], startPoint: .top, endPoint: .bottom)
                                )
                                .symbolEffect(.breathe, options: .repeating)
                        }

                        VStack(spacing: isPad ? 24 : 16) {
                            Text("Engineered for Respiratory Health")
                                .font(.system(isPad ? .largeTitle : .title, design: .rounded, weight: .bold))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.primary)
                                .minimumScaleFactor(0.8)

                            Text("Built initially for the daily struggles of Pulmonary Fibrosis, PulmoFlow is a dedicated therapeutic tool designed for anyone managing chronic respiratory conditions.\n\nBy uniting real-time acoustic analysis with proven clinical breathing protocols, it provides structured therapy to help you strengthen your lungs and regain control of your breath.")
                                .font(.system(isPad ? .title3 : .body, design: .rounded, weight: .medium))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                                .lineSpacing(6)
                                .padding(.horizontal, 4)
                        }
                    }
                    .padding(.horizontal, isPad ? 40 : 24)
                    .padding(.vertical, isPad ? 48 : 32)
                    .background(Color(uiColor: .tertiarySystemGroupedBackground).opacity(colorScheme == .dark ? 0.3 : 0.8))
                    .clipShape(RoundedRectangle(cornerRadius: isPad ? 40 : 32, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: isPad ? 40 : 32, style: .continuous)
                            .stroke(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.08), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(colorScheme == .dark ? 0.2 : 0.05), radius: 30)
                    .padding(20)
                }
                .tag(1)

                // Screen 3: Technical Prowess
                ResponsiveOnboardingPage {
                    VStack(spacing: isPad ? 50 : 30) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Built for Precision")
                                .font(.system(isPad ? .headline : .subheadline, design: .rounded, weight: .semibold))
                                .foregroundStyle(.teal)
                                .textCase(.uppercase)

                            Text("How PulmoFlow Works")
                                .font(.system(isPad ? .largeTitle : .title, design: .rounded, weight: .bold))
                                .foregroundColor(.primary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, isPad ? 40 : 32)

                        VStack(alignment: .leading, spacing: isPad ? 30 : 20) {
                            OnboardingFeatureRow(
                                icon: "waveform.and.mic",
                                title: "Acoustic Analysis",
                                subtext: "Real-time huff detection running completely on-device with zero-latency."
                            )
                            OnboardingFeatureRow(
                                icon: "applewatch",
                                title: "Ecosystem Sync",
                                subtext: "Seamless integration with HealthKit to track vital respiratory metrics."
                            )
                            OnboardingFeatureRow(
                                icon: "signature",
                                title: "Daily Pledge",
                                subtext: "Seal your daily respiratory efforts with a signature or photo to build a consistent habit."
                            )
                            OnboardingFeatureRow(
                                icon: "lock.shield",
                                title: "100% Private",
                                subtext: "No servers. Your personal health data never leaves your device."
                            )
                        }
                        .padding(.horizontal, isPad ? 40 : 32)
                    }
                }
                .tag(2)

                // Screen 4: Companion Mode Selection
                ResponsiveOnboardingPage {
                    VStack(spacing: isPad ? 30 : 20) {
                        VStack(spacing: 6) {
                            Text("Personalize Your Experience")
                                .font(.system(isPad ? .headline : .subheadline, design: .rounded, weight: .bold))
                                .foregroundStyle(.teal)
                                .tracking(1.0)
                                .textCase(.uppercase)

                            Text("Companion Mode")
                                .font(.system(isPad ? .largeTitle : .title, design: .rounded, weight: .bold))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 10)

                        ZStack {
                            Circle()
                                .fill(viewModel.selectedMode.color.opacity(0.15))
                                .frame(width: isPad ? 220 : 160, height: isPad ? 220 : 160)
                                .blur(radius: 30)

                            LiquidGlassOrb(tint: viewModel.selectedMode.color)
                                .matchedGeometryEffect(id: "orb", in: animationNamespace)
                                .frame(height: isPad ? 200 : 140)
                        }
                        .padding(.vertical, 10)

                        HStack(spacing: isPad ? 24 : 16) {
                            ForEach(CompanionMode.allCases, id: \.self) { mode in
                                CompanionModeGridCard(
                                    mode: mode,
                                    isSelected: viewModel.selectedMode == mode,
                                    action: {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                            viewModel.selectedMode = mode
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)

                        VStack(alignment: .leading, spacing: isPad ? 20 : 16) {
                            OnboardingFeatureRow(
                                icon: "sparkles",
                                title: "Adaptive Engine",
                                subtext: "Defines your feedback style. Biometrics stay entirely on-device."
                            )
                            OnboardingFeatureRow(
                                icon: "mic.badge.plus",
                                title: "Acoustic Intelligence",
                                subtext: "Requires microphone to analyze breath velocity. Processed 100% offline."
                            )
                        }
                        .padding(.horizontal, isPad ? 40 : 32)
                        .padding(.top, 10)
                    }
                }
                .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .overlay(alignment: .bottom) {
                Button(action: {
                    HapticManager.shared.playImpact(style: .light)
                    if currentPage < 3 {
                        withAnimation(.spring()) {
                            currentPage += 1
                        }
                    } else {
                        Task {
                            await viewModel.requestMicrophonePermission()
                            await MainActor.run {
                                successTrigger.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    viewModel.completeOnboarding()
                                }
                            }
                        }
                    }
                }) {
                    Text(currentPage < 3 ? "Continue" : "Sync with PulmoFlow")
                        .font(isPad ? .title2.bold() : .title3.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, isPad ? 24 : 20)
                        .background(.ultraThinMaterial)
                        .background(Color.teal.opacity(0.9))
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(colorScheme == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.14), lineWidth: 1)
                        )
                }
                .frame(maxWidth: isPad ? 500 : 400)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 40)
                .padding(.bottom, isPad ? 60 : 40)
                .sensoryFeedback(.success, trigger: successTrigger)
            }
        }
    }
}
