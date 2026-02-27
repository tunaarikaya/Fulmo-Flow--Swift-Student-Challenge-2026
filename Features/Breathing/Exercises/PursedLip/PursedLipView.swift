import SwiftUI

struct PursedLipView: View {
    @StateObject private var viewModel = PursedLipViewModel()
    var onFinish: () -> Void
    
    var body: some View {
        let exercise = viewModel.exerciseType
        let progress = viewModel.exactProgress
        
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                SessionProgressBar(progress: progress, tint: exercise.color)
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                
                Spacer(minLength: 24)
            
                ZStack {
                    SessionSphereView(
                        phase: viewModel.currentPhase,
                        phaseTimeRemaining: viewModel.phaseTimeRemaining,
                        phaseName: viewModel.currentPhase.displayName(for: exercise),
                        exerciseColor: exercise.color,
                        isComplete: viewModel.sessionTimeRemaining <= 0,
                        baseScale: viewModel.breathScale
                    )
                }
                .frame(maxWidth: .infinity)
                
                Spacer(minLength: 24)
                
                if viewModel.sessionTimeRemaining <= 0 {
                    Button(action: onFinish) {
                        Text("Finish Session")
                            .font(.system(.title3, design: .rounded, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                    }
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(exercise.color)
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(.ultraThinMaterial)
                                .opacity(0.25)
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(.white.opacity(0.35), lineWidth: 1.5)
                    )
                    .shadow(color: exercise.color.opacity(0.4), radius: 16, x: 0, y: 8)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 48)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Button(action: onFinish) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(.largeTitle, weight: .medium))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(Color.primary.opacity(0.8))
                    .frame(width: 52, height: 52)
                    .contentShape(Circle())
            }
            .background(
                Circle()
                    .fill(.ultraThinMaterial)
                    .overlay(Circle().stroke(.white.opacity(0.25), lineWidth: 1))
            )
            .accessibilityLabel("End session")
            .padding(.top, 8)
            .padding(.trailing, 20)
            .offset(y: 35)
            
            if viewModel.showMicrophoneAlert {
                MicPermissionAlertOverlay(
                    onCancel: onFinish,
                    onSettings: {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                )
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .transition(.scale)
        .sensoryFeedback(.success, trigger: viewModel.sessionComplete)
        .sensoryFeedback(.selection, trigger: viewModel.phaseChangeTrigger)
        .onAppear {
            viewModel.startSession()
        }
        .onDisappear {
            viewModel.endSession()
        }
    }
}
