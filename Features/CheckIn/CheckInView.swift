import SwiftUI
import PhotosUI
import UIKit

struct CheckInView: View {
    @StateObject private var viewModel = CheckInViewModel()
    @EnvironmentObject private var tabRouter: TabRouter
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    @Environment(\.colorScheme) private var colorScheme
    @AppStorage("hasSeenPaperKitInfo") private var hasSeenPaperKitInfo = false
    
    @State private var showPaperKitInfo = false
    @State private var displayedMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: .now)) ?? .now
    @State private var selectedInk: InkColorOption = .adaptive
    @State private var selectedStroke: CGFloat = 3
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var toolMode: MarkupToolMode = .pen
    @State private var isPhotoEditMode = false
    @State private var dragStartOffset: CGSize?
    @State private var pinchStartScale: CGFloat?
    
    private var selectedDayLabel: String {
        viewModel.selectedDate.formatted(.dateTime.weekday(.wide).day().month(.wide))
    }
    
    var body: some View {
        ZStack {
            CheckInBackground(reduceTransparency: reduceTransparency)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                CheckInHeaderView()
                    
                    CheckInCalendarCard(
                        viewModel: viewModel,
                        displayedMonth: $displayedMonth
                    )
                    
                    CheckInDrawingControls(
                        viewModel: viewModel,
                        toolMode: $toolMode,
                        selectedInk: $selectedInk,
                        selectedStroke: $selectedStroke,
                        selectedPhotoItem: $selectedPhotoItem,
                        isPhotoEditMode: $isPhotoEditMode
                    )
                    
                    CheckInCanvasCard(
                        viewModel: viewModel,
                        toolMode: $toolMode,
                        selectedInk: $selectedInk,
                        selectedStroke: $selectedStroke,
                        isPhotoEditMode: $isPhotoEditMode,
                        dragStartOffset: $dragStartOffset,
                        pinchStartScale: $pinchStartScale
                    )
                    
                    CheckInToolbar(
                        viewModel: viewModel,
                        showPaperKitInfo: $showPaperKitInfo
                    )
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, 24)
            
            if showPaperKitInfo {
                Color.black.opacity(colorScheme == .dark ? 0.6 : 0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            hasSeenPaperKitInfo = true
                            showPaperKitInfo = false
                        }
                    }
                    .transition(.opacity)
                
                PaperKitInfoSheet {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        hasSeenPaperKitInfo = true
                        showPaperKitInfo = false
                    }
                }
                .transition(.scale(scale: 0.95).combined(with: .opacity))
                .zIndex(2)
            }
        }
        .confirmationDialog("Clear Canvas", isPresented: $viewModel.showClearConfirmation, titleVisibility: .visible) {
            Button("Clear", role: .destructive) {
                viewModel.clearCanvas()
            }
            Button("Cancel", role: .cancel) {
                viewModel.cancelClear()
            }
        } message: {
            Text("Remove all writing and drawings for \(selectedDayLabel)?")
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: viewModel.clearConfirmTrigger)
        .onAppear {
            displayedMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: viewModel.selectedDate)) ?? viewModel.selectedDate
            if !hasSeenPaperKitInfo {
                // Ensure layout completes first before showing splash
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        showPaperKitInfo = true
                    }
                }
            }
        }
        .onChange(of: selectedPhotoItem) { _, newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    await MainActor.run {
                        viewModel.setPhoto(image)
                        isPhotoEditMode = true
                    }
                }
            }
        }
        .onChange(of: viewModel.selectedDate) { _, _ in
            dragStartOffset = nil
            pinchStartScale = nil
            isPhotoEditMode = false
        }
        .onChange(of: tabRouter.checkInTargetDate) { _, newDate in
            if let newDate {
                viewModel.selectDate(newDate)
                displayedMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: newDate)) ?? newDate
                tabRouter.checkInTargetDate = nil // reset
            }
        }
    }
}

#Preview {
    CheckInView()
        .environmentObject(TabRouter())
}
