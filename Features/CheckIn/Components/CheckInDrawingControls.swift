import SwiftUI
import PhotosUI

struct CheckInDrawingControls: View {
    @ObservedObject var viewModel: CheckInViewModel
    @Binding var toolMode: MarkupToolMode
    @Binding var selectedInk: InkColorOption
    @Binding var selectedStroke: CGFloat
    @Binding var selectedPhotoItem: PhotosPickerItem?
    @Binding var isPhotoEditMode: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    private var strokeOptions: [CGFloat] = [2, 4, 7]
    
    init(
        viewModel: CheckInViewModel,
        toolMode: Binding<MarkupToolMode>,
        selectedInk: Binding<InkColorOption>,
        selectedStroke: Binding<CGFloat>,
        selectedPhotoItem: Binding<PhotosPickerItem?>,
        isPhotoEditMode: Binding<Bool>
    ) {
        self.viewModel = viewModel
        self._toolMode = toolMode
        self._selectedInk = selectedInk
        self._selectedStroke = selectedStroke
        self._selectedPhotoItem = selectedPhotoItem
        self._isPhotoEditMode = isPhotoEditMode
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                // Tools (Pen/Eraser)
                HStack(spacing: 4) {
                    Button {
                        toolMode = .pen
                    } label: {
                        Image(systemName: "pencil.tip")
                            .font(.system(.title3, weight: .medium))
                            .frame(width: 44, height: 44)
                            .background(toolMode == .pen ? Color.teal : Color.clear)
                            .foregroundStyle(toolMode == .pen ? .white : .primary)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Pen Tool")
                    .accessibilityAddTraits(toolMode == .pen ? .isSelected : [])
                    
                    Button {
                        toolMode = .eraser
                    } label: {
                        Image(systemName: "eraser")
                            .font(.system(.title3, weight: .medium))
                            .frame(width: 44, height: 44)
                            .background(toolMode == .eraser ? Color.teal : Color.clear)
                            .foregroundStyle(toolMode == .eraser ? .white : .primary)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Eraser Tool")
                    .accessibilityAddTraits(toolMode == .eraser ? .isSelected : [])
                }
                .padding(4)
                .background(colorScheme == .dark ? .white.opacity(0.1) : .black.opacity(0.05))
                .clipShape(Capsule())
                
                // Active Color Indicator and Palette
                HStack(spacing: 12) {
                    ForEach(InkColorOption.allCases) { option in
                        Button {
                            selectedInk = option
                        } label: {
                            option.colorPreview(for: colorScheme)
                                .frame(width: 34, height: 34)
                                .overlay(
                                    Circle()
                                        .stroke(option == selectedInk ? Color.primary : Color.clear, lineWidth: option == selectedInk ? 3 : 0)
                                        .padding(-4)
                                )
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("\(option.rawValue.capitalized) Color")
                        .accessibilityAddTraits(option == selectedInk ? .isSelected : [])
                    }
                }
                
                // Separator
                Rectangle()
                    .fill(.primary.opacity(0.1))
                    .frame(width: 1, height: 32)
                
                // Stroke Width Menu
                Menu {
                    ForEach(strokeOptions, id: \.self) { width in
                        Button {
                            selectedStroke = width
                        } label: {
                            Text(width == 2 ? "Fine" : (width == 4 ? "Medium" : "Bold"))
                        }
                    }
                } label: {
                    Image(systemName: "lineweight")
                        .font(.system(.title3, weight: .medium))
                        .frame(width: 44, height: 44)
                        .foregroundStyle(.primary)
                        .background(colorScheme == .dark ? .white.opacity(0.1) : .black.opacity(0.05))
                        .clipShape(Circle())
                }
                .accessibilityLabel("Stroke Width")
                .accessibilityValue(selectedStroke == 2 ? "Fine" : (selectedStroke == 4 ? "Medium" : "Bold"))
                
                // Photo Actions
                if viewModel.selectedPhoto == nil {
                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                        Image(systemName: "photo.badge.plus")
                            .font(.system(.title3, weight: .medium))
                            .frame(width: 44, height: 44)
                            .foregroundStyle(.white)
                            .background(Color.teal)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Add Photo")
                } else {
                    Menu {
                        Button {
                            isPhotoEditMode.toggle()
                        } label: {
                            Label(isPhotoEditMode ? "Done Layout" : "Adjust Layout", systemImage: isPhotoEditMode ? "checkmark" : "arrow.up.left.and.arrow.down.right")
                        }
                        Button {
                            viewModel.resetPhotoTransform()
                        } label: {
                            Label("Reset Image", systemImage: "arrow.counterclockwise")
                        }
                        Button(role: .destructive) {
                            viewModel.clearPhoto()
                            isPhotoEditMode = false
                        } label: {
                            Label("Remove Photo", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "photo.fill")
                            .font(.system(.title3, weight: .medium))
                            .frame(width: 44, height: 44)
                            .foregroundStyle(.white)
                            .background(Color.teal)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(isPhotoEditMode ? .orange : .clear, lineWidth: 2)
                                    .padding(-4)
                            )
                    }
                    .accessibilityLabel("Photo Options")
                    .accessibilityHint("Double tap to adjust or remove photo")
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(colorScheme == .dark ? 0.3 : 0.08), radius: 12, x: 0, y: 6)
            .padding(.vertical, 8) // ScrollView top/bottom padding for the shadow
            .padding(.horizontal, 4)
        }
    }
}
