import SwiftUI
import PencilKit
import UIKit

struct PhotoLayout: Codable {
    let scale: Double
    let offsetX: Double
    let offsetY: Double
    let opacity: Double
}

@MainActor
final class JournalManager {
    static let shared = JournalManager()
    
    private let filePrefix = "daily_reflection_"
    private let fileExtension = "drawing"
    private let photoPrefix = "daily_photo_"
    private let photoExtension = "jpg"
    private let photoLayoutPrefix = "daily_photo_layout_"
    private let photoLayoutExtension = "json"
    private let calendar = Calendar.current
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private var documentsDirectory: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir
    }
    
    private func normalizedDay(_ date: Date) -> Date {
        calendar.startOfDay(for: date)
    }
    
    private func fileURL(for date: Date) -> URL {
        let dayKey = dateFormatter.string(from: normalizedDay(date))
        return documentsDirectory.appendingPathComponent("\(filePrefix)\(dayKey).\(fileExtension)")
    }
    
    func save(drawing: PKDrawing, for date: Date) {
        do {
            let data = drawing.dataRepresentation()
            try data.write(to: fileURL(for: date))
        } catch {
            print("JournalManager save error: \(error.localizedDescription)")
        }
    }
    
    func load(for date: Date) -> PKDrawing? {
        let url = fileURL(for: date)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        do {
            let data = try Data(contentsOf: url)
            return try PKDrawing(data: data)
        } catch {
            print("JournalManager load error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func clearDrawing(for date: Date) {
        let url = fileURL(for: date)
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("JournalManager clear error: \(error.localizedDescription)")
        }
    }
    
    func savePhoto(_ image: UIImage, for date: Date) {
        guard let data = image.jpegData(compressionQuality: 0.9) else { return }
        let dayKey = dateFormatter.string(from: normalizedDay(date))
        let url = documentsDirectory.appendingPathComponent("\(photoPrefix)\(dayKey).\(photoExtension)")
        do {
            try data.write(to: url)
        } catch {
            print("JournalManager photo save error: \(error.localizedDescription)")
        }
    }
    
    func loadPhoto(for date: Date) -> UIImage? {
        let dayKey = dateFormatter.string(from: normalizedDay(date))
        let url = documentsDirectory.appendingPathComponent("\(photoPrefix)\(dayKey).\(photoExtension)")
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        return UIImage(contentsOfFile: url.path)
    }
    
    func clearPhoto(for date: Date) {
        let dayKey = dateFormatter.string(from: normalizedDay(date))
        let url = documentsDirectory.appendingPathComponent("\(photoPrefix)\(dayKey).\(photoExtension)")
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("JournalManager photo clear error: \(error.localizedDescription)")
        }
    }
    
    func savePhotoLayout(_ layout: PhotoLayout, for date: Date) {
        let dayKey = dateFormatter.string(from: normalizedDay(date))
        let url = documentsDirectory.appendingPathComponent("\(photoLayoutPrefix)\(dayKey).\(photoLayoutExtension)")
        do {
            let data = try JSONEncoder().encode(layout)
            try data.write(to: url)
        } catch {
            print("JournalManager photo layout save error: \(error.localizedDescription)")
        }
    }
    
    func loadPhotoLayout(for date: Date) -> PhotoLayout? {
        let dayKey = dateFormatter.string(from: normalizedDay(date))
        let url = documentsDirectory.appendingPathComponent("\(photoLayoutPrefix)\(dayKey).\(photoLayoutExtension)")
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(PhotoLayout.self, from: data)
        } catch {
            print("JournalManager photo layout load error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func clearPhotoLayout(for date: Date) {
        let dayKey = dateFormatter.string(from: normalizedDay(date))
        let url = documentsDirectory.appendingPathComponent("\(photoLayoutPrefix)\(dayKey).\(photoLayoutExtension)")
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("JournalManager photo layout clear error: \(error.localizedDescription)")
        }
    }
    
    func availableEntryDays() -> Set<Date> {
        guard let files = try? FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil) else {
            return []
        }
        
        let prefixLength = filePrefix.count
        return Set(files.compactMap { url in
            let name = url.deletingPathExtension().lastPathComponent
            let dayKey: String
            if url.pathExtension == fileExtension, name.hasPrefix(filePrefix) {
                dayKey = String(name.dropFirst(prefixLength))
            } else if url.pathExtension == photoExtension, name.hasPrefix(photoPrefix) {
                dayKey = String(name.dropFirst(photoPrefix.count))
            } else {
                return nil
            }
            guard let parsedDate = dateFormatter.date(from: dayKey) else { return nil }
            return normalizedDay(parsedDate)
        })
    }
    
    // MARK: - Pre-Populated Mock Data (Narrative Engineering)
    func loadMockDataIfNeeded() {
        let currentYear = calendar.component(.year, from: .now)
        var components = DateComponents()
        components.year = currentYear
        components.month = 3
        components.day = 2
        
        guard let targetDate = calendar.date(from: components) else { return }
        let dayKey = dateFormatter.string(from: normalizedDay(targetDate))
        let drawingUrl = documentsDirectory.appendingPathComponent("\(filePrefix)\(dayKey).\(fileExtension)")
        let photoUrl = documentsDirectory.appendingPathComponent("\(photoPrefix)\(dayKey).\(photoExtension)")
        
        // If data already exists for this day, don't overwrite it.
        if FileManager.default.fileExists(atPath: drawingUrl.path) || FileManager.default.fileExists(atPath: photoUrl.path) {
            return
        }
        
        // 1. Save "dedem<3" Photo
        if let mockImage = UIImage(named: "dedem<3") {
            savePhoto(mockImage, for: targetDate)
            
            // 2. Save Photo Layout (Positioned to the extreme left, scaled to naturally fit)
            let layout = PhotoLayout(scale: 0.95, offsetX: -200, offsetY: 0, opacity: 1.0)
            savePhotoLayout(layout, for: targetDate)
        }
        
        // 3. Instead of synthetic drawing (which was rendering as primitive lines), 
        // we write an empty drawing data here. We will intercept the date "Mar 2" 
        // in `CheckInCanvasCard` to render beautiful cursive Text natively, 
        // ensuring it looks perfect for the Apple Design Award presentation.
        let drawing = PKDrawing()
        save(drawing: drawing, for: targetDate)
    }
}
