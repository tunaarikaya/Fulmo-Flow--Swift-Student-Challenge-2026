import SwiftUI

struct BreathingView: View {
    @StateObject private var viewModel = BreathingViewModel()
    @Namespace private var animationNamespace
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var showCompletion = false
    @State private var completedExerciseTitle = ""
    
    var body: some View {
        ZStack {
            // Mesh-style Animated Background
            BreathingPulseBackground()
                .ignoresSafeArea()
            
            // Main Content Layer
            VStack(spacing: 40) {
                // Header Area
                if viewModel.activeSessionExercise == nil {
                     headerView
                        .opacity(viewModel.showDetail ? 0 : 1)
                        .blur(radius: viewModel.showDetail ? 10 : 0)
                }
                
                // Session Active View
                if let exercise = viewModel.activeSessionExercise {
                    switch exercise {
                    case .pursedLip:
                        PursedLipView(onFinish: { handleFinish(exercise: exercise) })
                    case .rescue:
                        RescueView(onFinish: { handleFinish(exercise: exercise) })
                    case .huff:
                        HuffView(onFinish: { handleFinish(exercise: exercise) })
                    }
                } 
                else {
                    exercisesGrid
                        .blur(radius: viewModel.showDetail ? 5 : 0)
                        .scaleEffect(viewModel.showDetail ? 0.95 : 1.0)
                }
            }
            // Detail Overlay (animation disabled for testing — instant open/close)
            if viewModel.showDetail, let exercise = viewModel.selectedExercise {
                ExerciseDetailOverlay(
                    exercise: exercise,
                    namespace: animationNamespace,
                    onDismiss: { viewModel.closeDetail() },
                    onStart: { viewModel.startSession() }
                )
                .zIndex(100)
            }
            
            // Completion Overlay (Replaces the .sheet)
            if showCompletion {
                Color.black.opacity(colorScheme == .dark ? 0.6 : 0.3)
                    .ignoresSafeArea()
                    .zIndex(199)
                    .onTapGesture { showCompletion = false }
                
                CompletionSheet(
                    exerciseTitle: completedExerciseTitle,
                    onDismiss: { showCompletion = false }
                )
                .zIndex(200)
                .transition(.scale(scale: 0.9).combined(with: .opacity))
            }
        }
    }
    
    private func handleFinish(exercise: BreathingExercise) {
        viewModel.endSession()
        completedExerciseTitle = exercise.rawValue
        
        // Slight delay so the exercise view closes before the sheet pops up
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            showCompletion = true
        }
    }
    
    // MARK: - Subviews
    
    var headerView: some View {
        VStack(spacing: 20) {
            ZStack {
                LiquidGlassOrbView()
                    .frame(width: 200, height: 200)
            }
            .accessibilityHidden(true) // purely decorative
            
            Text("Select an exercise to begin")
                .font(.system(.largeTitle, design: .rounded, weight: .bold)) // HIG Dynamic Type
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)
        }
        .padding(.top, 40)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
    
    var exercisesGrid: some View {
        VStack(spacing: 20) {
            // Huff Challenge (Top)
            ExerciseCard(
                exercise: .huff,
                namespace: animationNamespace,
                useMatchedGeometry: !(viewModel.showDetail && viewModel.selectedExercise == .huff)
            )
            .opacity(viewModel.showDetail && viewModel.selectedExercise == .huff ? 0 : 1)
            .onTapGesture { viewModel.select(.huff) }
            
            // Bottom Row
            HStack(spacing: 20) {
                ExerciseCard(
                    exercise: .pursedLip,
                    namespace: animationNamespace,
                    useMatchedGeometry: !(viewModel.showDetail && viewModel.selectedExercise == .pursedLip)
                )
                .opacity(viewModel.showDetail && viewModel.selectedExercise == .pursedLip ? 0 : 1)
                .onTapGesture { viewModel.select(.pursedLip) }
                
                ExerciseCard(
                    exercise: .rescue,
                    namespace: animationNamespace,
                    useMatchedGeometry: !(viewModel.showDetail && viewModel.selectedExercise == .rescue)
                )
                .opacity(viewModel.showDetail && viewModel.selectedExercise == .rescue ? 0 : 1)
                .onTapGesture { viewModel.select(.rescue) }
            }
        }
        .padding(.horizontal, 30)
    }
}
