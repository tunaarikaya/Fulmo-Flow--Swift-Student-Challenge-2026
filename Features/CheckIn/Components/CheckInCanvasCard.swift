import SwiftUI

struct CheckInCanvasCard: View {
    @ObservedObject var viewModel: CheckInViewModel
    @Binding var toolMode: MarkupToolMode
    @Binding var selectedInk: InkColorOption
    @Binding var selectedStroke: CGFloat
    @Binding var isPhotoEditMode: Bool
    
    @Binding var dragStartOffset: CGSize?
    @Binding var pinchStartScale: CGFloat?
    
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    @Environment(\.colorScheme) private var colorScheme
    
    init(
        viewModel: CheckInViewModel,
        toolMode: Binding<MarkupToolMode>,
        selectedInk: Binding<InkColorOption>,
        selectedStroke: Binding<CGFloat>,
        isPhotoEditMode: Binding<Bool>,
        dragStartOffset: Binding<CGSize?>,
        pinchStartScale: Binding<CGFloat?>
    ) {
        self.viewModel = viewModel
        self._toolMode = toolMode
        self._selectedInk = selectedInk
        self._selectedStroke = selectedStroke
        self._isPhotoEditMode = isPhotoEditMode
        self._dragStartOffset = dragStartOffset
        self._pinchStartScale = pinchStartScale
    }
    
    var body: some View {
        Group {
            if reduceTransparency {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
            } else {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.4), .white.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .fill(.cyan.opacity(0.06))
                    )
            }
        }
        .overlay(
            GeometryReader { proxy in
                let width = proxy.size.width
                let height = proxy.size.height
                
                // iPad Mini portrait card space is roughly 650x450.
                // We use these as base values. If the screen is larger, we scale up aggressively.
                let widthScale = width / 650.0
                let heightScale = height / 450.0
                
                // Use the smaller scale to ensure it fits both horizontally and vertically
                let rawScale = min(widthScale, heightScale)
                let scale = min(max(rawScale, 0.85), 2.4)
                
                ZStack {
                    PaperMarkupView(
                        drawing: $viewModel.drawing,
                        inkColor: selectedInk.uiColor(for: colorScheme),
                        inkWidth: selectedStroke,
                        toolMode: toolMode,
                        isInteractionEnabled: !isPhotoEditMode,
                        onDrawingChange: { viewModel.saveDrawing($0) }
                    )
                    .padding(20)
                
                if let photo = viewModel.selectedPhoto {
                    Image(uiImage: photo)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: isTargetDate ? 280 * scale : nil, height: isTargetDate ? 340 * scale : nil)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        // Optional Polaroid frame simulation for target date
                        .padding(isTargetDate ? 9 * scale : 0)
                        .padding(.bottom, isTargetDate ? 32 * scale : 0)
                        .background(isTargetDate ? Color(red: 0.95, green: 0.95, blue: 0.92) : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: isTargetDate ? 16 * scale : 12, style: .continuous))
                        .shadow(color: .black.opacity(0.3), radius: 15 * scale, x: 0, y: 10 * scale)
                        .padding(16 * scale)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .scaleEffect(isTargetDate ? 0.90 : viewModel.photoScale)
                        .offset(isTargetDate ? CGSize(width: -145 * scale, height: 0) : viewModel.photoOffset)
                        .rotationEffect(isTargetDate ? .degrees(-4) : .zero)
                        .opacity(viewModel.photoOpacity)
                        .allowsHitTesting(isPhotoEditMode)
                        .overlay(alignment: .topTrailing) {
                            if isPhotoEditMode {
                                Image(systemName: "arrow.up.left.and.arrow.down.right")
                                    .font(.caption.weight(.semibold))
                                    .padding(8)
                                    .background(.black.opacity(0.45))
                                    .foregroundStyle(.white)
                                    .clipShape(Circle())
                                    .padding(18)
                            }
                        }
                        .gesture(photoTransformGesture)
                }
                
                // Narrative Engineering: Handwritten text overlay for the target example date
                if isTargetDate {
                    HStack {
                        Spacer() // Push text to the right side
                        
                        VStack(alignment: .leading, spacing: 10 * scale) {
                            VStack(alignment: .leading, spacing: 4 * scale) {
                                Text("I am continuing my")
                                Text("exercises for my loved")
                                Text("ones and grandchildren.")
                            }
                            .font(.custom("Bradley Hand", size: 27 * scale))
                            .fontWeight(.medium)
                            // Simulated Apple Pencil ink blending (cyan/teal theme)
                            .foregroundStyle(colorScheme == .dark ? Color(red: 0.4, green: 0.9, blue: 0.95) : Color(red: 0.05, green: 0.5, blue: 0.6))
                            .opacity(0.85)
                            .shadow(color: .cyan.opacity(colorScheme == .dark ? 0.3 : 0.1), radius: 1, x: 0.5 * scale, y: 0.5 * scale)
                            
                            Text("Mehmet")
                                .font(.custom("Snell Roundhand", size: 60 * scale)) // Real signature font
                                .fontWeight(.bold)
                                .foregroundStyle(colorScheme == .dark ? Color(red: 0.3, green: 0.85, blue: 0.9) : Color(red: 0.0, green: 0.45, blue: 0.55))
                                .opacity(0.95)
                                .padding(.leading, 60 * scale)
                                .padding(.top, 6 * scale)
                                .rotationEffect(.degrees(-8)) // Extra tilt for signature
                        }
                        .rotationEffect(.degrees(-5)) // Slope entire block
                        .padding(.trailing, width * 0.06) // Flush to use maximum space, dynamically adjusted
                        .offset(x: 14 * scale)
                    }
                    .allowsHitTesting(false)
                }
                
                if viewModel.drawing.bounds.isEmpty, viewModel.selectedPhoto == nil {
                    VStack(spacing: 8) {
                        Image(systemName: "signature")
                            .font(.system(.title3, weight: .medium))
                            .foregroundStyle(.secondary)
                        Text("Sign to seal today's effort")
                            .font(.system(.subheadline, design: .rounded, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                    .allowsHitTesting(false)
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        )
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: .black.opacity(colorScheme == .dark ? 0.12 : 0.08), radius: 24, x: 0, y: 12)
        .frame(minHeight: 200, maxHeight: .infinity)
        .frame(maxWidth: .infinity)
    }
    
    private var isTargetDate: Bool {
        let calendar = Calendar.current
        return calendar.component(.month, from: viewModel.selectedDate) == 3 && 
               calendar.component(.day, from: viewModel.selectedDate) == 2
    }
    
    private var photoTransformGesture: some Gesture {
        SimultaneousGesture(
            DragGesture()
                .onChanged { value in
                    guard isPhotoEditMode else { return }
                    if dragStartOffset == nil {
                        dragStartOffset = viewModel.photoOffset
                    }
                    let start = dragStartOffset ?? .zero
                    viewModel.updatePhotoTransform(
                        offset: CGSize(
                            width: start.width + value.translation.width,
                            height: start.height + value.translation.height
                        )
                    )
                }
                .onEnded { _ in
                    guard isPhotoEditMode else { return }
                    dragStartOffset = nil
                    viewModel.persistPhotoLayout()
                },
            MagnificationGesture()
                .onChanged { value in
                    guard isPhotoEditMode else { return }
                    if pinchStartScale == nil {
                        pinchStartScale = viewModel.photoScale
                    }
                    let start = pinchStartScale ?? 1
                    viewModel.updatePhotoTransform(scale: start * value)
                }
                .onEnded { _ in
                    guard isPhotoEditMode else { return }
                    pinchStartScale = nil
                    viewModel.persistPhotoLayout()
                }
        )
    }
}
