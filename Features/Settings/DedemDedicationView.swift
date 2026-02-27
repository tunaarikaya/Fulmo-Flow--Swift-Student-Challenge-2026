import SwiftUI

struct DedemDedicationView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                // App's solid background instead of glassy/transparent overlay
                MeshGradientBackground()
                    .ignoresSafeArea()
                    .onTapGesture { dismiss() }
                
                let isLandscape = proxy.size.width > proxy.size.height
                
                // The BIG Premium Card
                VStack(spacing: 0) {
                    
                    // MARK: - Safely Padded, Uncropped Image
                    // No more stretching to the edges. Just a beautiful, clean, framed photo.
                    ZStack {
                        Image("dedem<3")
                            .resizable()
                            .scaledToFit() // 100% Guaranteed to never crop the image
                            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                            .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 10)
                    }
                    .frame(height: proxy.size.height * (isLandscape ? 0.35 : 0.30)) // Increased space for text by shrinking photo slightly
                    .padding(.top, isLandscape ? 32 : 40)
                    .padding(.horizontal, isLandscape ? 32 : 40)
                    // Merged background to the parent container
                    
                    
                    // MARK: - Spacious Text Content Area
                    VStack(alignment: .leading, spacing: isLandscape ? 16 : 24) {
                        Text("A Tribute to My Grandfather")
                            .font(.system(isLandscape ? .title : .largeTitle, design: .rounded, weight: .bold))
                            .foregroundStyle(.primary)
                            .minimumScaleFactor(0.8)
                        
                        VStack(alignment: .leading, spacing: isLandscape ? 12 : 16) {
                            Text("I didn't start this project to build an app. I started it because I couldn't stand the sound of my grandfather struggling to breathe.")
                            Text("When he was diagnosed with Pulmonary Fibrosis, I spent a lot of time sitting next to him, listening to the hum of his oxygen machine, feeling completely useless. \(Text("You can't breathe for someone else. But I knew how to code.").font(.system(isLandscape ? .headline : .title2, design: .rounded, weight: .heavy)).foregroundColor(.primary))")
                            
                            Text("This is a labor of love dedicated to my grandfather, who has been my greatest source of inspiration and strength. I built PulmoFlow to be a quiet companion on the days when the air felt too thin.")
                            
                            Text("My deepest wish is that this tool provides even a small spark of hope and clarity to those facing similar journeys. To my grandfather, and to every soul fighting for every breath may you always know that you are not alone on this path.")
                        }
                        .font(.system(isLandscape ? .body : .title3, design: .rounded, weight: .medium))
                        .lineSpacing(isLandscape ? 4 : 6)
                        .foregroundStyle(.primary.opacity(0.85))
                        .minimumScaleFactor(0.5) // Safely allows text to shrink down up to 50% without truncating
                        
                        Spacer(minLength: 8)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("With eternal love and gratitude,")
                                .font(.system(isLandscape ? .subheadline : .headline, design: .rounded).italic())
                                .foregroundStyle(.secondary)
                            
                            Text("Mehmet Tuna Arıkaya")
                                .font(.system(isLandscape ? .title3 : .title2, design: .rounded, weight: .bold))
                                .foregroundStyle(.teal)
                                .minimumScaleFactor(0.8)
                        }
                    }
                    .padding(isLandscape ? 32 : 44)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                }
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 36, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 36, style: .continuous)
                        .stroke(Color.white.opacity(colorScheme == .dark ? 0.15 : 0.4), lineWidth: 1.5)
                )
                .shadow(color: .black.opacity(colorScheme == .dark ? 0.4 : 0.2), radius: 40, x: 0, y: 20)
                // Dev kart sınırları korundu
                .frame(
                    width: min(820, proxy.size.width * 0.92),
                    height: min(960, proxy.size.height * 0.92)
                )
                .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
                
                // Floating Close Button
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(.largeTitle, weight: .medium))
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.primary.opacity(0.8))
                                .background(
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                        .overlay(Circle().stroke(.white.opacity(0.25), lineWidth: 1))
                                )
                        }
                        .accessibilityLabel("Close Dedication")
                        .padding(32)
                    }
                    Spacer()
                }
            }
        }
        .presentationBackground(.clear)
    }
}

#Preview {
    Color.blue // Mock background to show transparency
        .ignoresSafeArea()
        .fullScreenCover(isPresented: .constant(true)) {
            DedemDedicationView()
        }
}
