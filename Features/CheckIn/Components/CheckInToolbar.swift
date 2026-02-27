import SwiftUI

public struct CheckInToolbar: View {
    @ObservedObject var viewModel: CheckInViewModel
    @Binding var showPaperKitInfo: Bool
    
    public init(viewModel: CheckInViewModel, showPaperKitInfo: Binding<Bool>) {
        self.viewModel = viewModel
        self._showPaperKitInfo = showPaperKitInfo
    }
    
    public var body: some View {
        HStack(spacing: 16) {
            Button {
                viewModel.requestClearCanvas()
            } label: {
                Label("Clear Selected Day", systemImage: "trash")
                    .font(.system(.callout, design: .rounded, weight: .semibold))
            }
            .buttonStyle(.borderedProminent)
            .tint(.teal)
            
            Spacer()
            
            Button {
                showPaperKitInfo = true
            } label: {
                Label("PaperKit Info", systemImage: "info.circle")
                    .font(.system(.callout, design: .rounded, weight: .medium))
            }
            .buttonStyle(.bordered)
        }
        .padding(.top, 8)
    }
}
