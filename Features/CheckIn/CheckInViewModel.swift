import SwiftUI
import PencilKit
import UIKit

// MARK: - Check-In ViewModel (MVVM)

@MainActor
public class CheckInViewModel: ObservableObject {
    @Published public private(set) var selectedDate: Date
    @Published public var drawing = PKDrawing()
    @Published public private(set) var selectedPhoto: UIImage?
    @Published public var photoScale: CGFloat = 1
    @Published public var photoOffset: CGSize = .zero
    @Published public var photoOpacity: Double = 1
    @Published public var showClearConfirmation = false
    @Published public var clearConfirmTrigger = UUID()
    @Published public private(set) var availableEntryDates: Set<Date> = []
    
    private let journal = JournalManager.shared
    private let calendar = Calendar.current
    
    public init() {
        selectedDate = calendar.startOfDay(for: .now)
        journal.loadMockDataIfNeeded()
        availableEntryDates = journal.availableEntryDays()
        loadDrawing(for: selectedDate)
    }
    
    public func saveDrawing(_ newDrawing: PKDrawing) {
        drawing = newDrawing
        journal.save(drawing: newDrawing, for: selectedDate)
        availableEntryDates.insert(selectedDate)
    }
    
    public func setPhoto(_ image: UIImage) {
        selectedPhoto = image
        photoScale = 1
        photoOffset = .zero
        photoOpacity = 1
        journal.savePhoto(image, for: selectedDate)
        persistPhotoLayout()
        availableEntryDates.insert(selectedDate)
    }
    
    public func clearPhoto() {
        selectedPhoto = nil
        photoScale = 1
        photoOffset = .zero
        photoOpacity = 1
        journal.clearPhoto(for: selectedDate)
        journal.clearPhotoLayout(for: selectedDate)
        if drawing.bounds.isEmpty {
            availableEntryDates.remove(selectedDate)
        }
    }
    
    public func updatePhotoTransform(scale: CGFloat? = nil, offset: CGSize? = nil, opacity: Double? = nil) {
        if let scale {
            photoScale = min(max(scale, 0.4), 3.0)
        }
        if let offset {
            photoOffset = offset
        }
        if let opacity {
            photoOpacity = min(max(opacity, 0.2), 1.0)
        }
    }
    
    public func resetPhotoTransform() {
        photoScale = 1
        photoOffset = .zero
        photoOpacity = 1
        persistPhotoLayout()
    }
    
    public func persistPhotoLayout() {
        guard selectedPhoto != nil else { return }
        journal.savePhotoLayout(
            PhotoLayout(
                scale: Double(photoScale),
                offsetX: Double(photoOffset.width),
                offsetY: Double(photoOffset.height),
                opacity: photoOpacity
            ),
            for: selectedDate
        )
    }
    
    public func selectDate(_ date: Date) {
        let normalized = calendar.startOfDay(for: date)
        guard normalized != selectedDate else { return }
        selectedDate = normalized
        loadDrawing(for: normalized)
    }
    
    public func hasEntry(on date: Date) -> Bool {
        availableEntryDates.contains(calendar.startOfDay(for: date))
    }
    
    public func requestClearCanvas() {
        showClearConfirmation = true
        clearConfirmTrigger = UUID()
    }
    
    public func clearCanvas() {
        // Clear drawing
        drawing = PKDrawing()
        journal.clearDrawing(for: selectedDate)
        
        // Clear photo
        selectedPhoto = nil
        photoScale = 1
        photoOffset = .zero
        photoOpacity = 1
        journal.clearPhoto(for: selectedDate)
        journal.clearPhotoLayout(for: selectedDate)
        
        availableEntryDates.remove(selectedDate)
        showClearConfirmation = false
    }
    
    public func cancelClear() {
        showClearConfirmation = false
    }
    
    /// Placeholder for final version: Apple Intelligence analyzes handwriting → HealthKit State of Mind
    public func analyzeWithAI() {
        // Hidden / future: analyze canvas content and update HKStateOfMind
    }
    
    private func loadDrawing(for date: Date) {
        drawing = journal.load(for: date) ?? PKDrawing()
        selectedPhoto = journal.loadPhoto(for: date)
        if let layout = journal.loadPhotoLayout(for: date), selectedPhoto != nil {
            photoScale = CGFloat(layout.scale)
            photoOffset = CGSize(width: layout.offsetX, height: layout.offsetY)
            photoOpacity = layout.opacity
        } else {
            photoScale = 1
            photoOffset = .zero
            photoOpacity = 1
        }
    }
}
