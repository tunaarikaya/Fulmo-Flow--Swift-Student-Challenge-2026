import SwiftUI
import PencilKit

enum MarkupToolMode {
    case pen
    case eraser
}

/// SwiftUI wrapper for the markup canvas. Uses PencilKit (PKCanvasView) for drawing and annotations.
/// On iPadOS 26 with PaperKit available, this can host PaperMarkupViewController with FeatureSet.latest
/// for full PaperKit markup (shapes, text boxes, etc.) and MarkupEditViewController insertion menu.
struct PaperMarkupView: UIViewRepresentable {
    @Binding var drawing: PKDrawing
    var inkColor: UIColor = .label
    var inkWidth: CGFloat = 2
    var toolMode: MarkupToolMode = .pen
    var isInteractionEnabled: Bool = true
    var onDrawingChange: ((PKDrawing) -> Void)?
    
    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        canvas.drawing = drawing
        canvas.delegate = context.coordinator
        canvas.backgroundColor = .clear
        canvas.isOpaque = false
        canvas.drawingPolicy = .anyInput
        canvas.isScrollEnabled = false
        canvas.isUserInteractionEnabled = isInteractionEnabled
        canvas.tool = currentTool
        return canvas
    }
    
    func updateUIView(_ canvas: PKCanvasView, context: Context) {
        // Guard against feedback loop: only update if the drawing actually differs
        // (i.e. the change came from outside, not from the user drawing on the canvas)
        if canvas.drawing != drawing {
            canvas.drawing = drawing
        }
        canvas.tool = currentTool
        canvas.isUserInteractionEnabled = isInteractionEnabled
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: PaperMarkupView
        
        init(_ parent: PaperMarkupView) {
            self.parent = parent
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            let newDrawing = canvasView.drawing
            // Defer the state mutation to the next run loop tick to avoid
            // "Publishing changes from within view updates" runtime warnings.
            DispatchQueue.main.async {
                self.parent.drawing = newDrawing
                self.parent.onDrawingChange?(newDrawing)
            }
        }
    }
    
    private var currentTool: PKTool {
        switch toolMode {
        case .pen:
            return PKInkingTool(.pen, color: inkColor, width: inkWidth)
        case .eraser:
            return PKEraserTool(.vector)
        }
    }
}
