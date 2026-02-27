import SwiftUI
import Observation

@Observable
class SettingsViewModel {

    // MARK: - Profile (UserDefaults persistence)
    var profile = ProfileModel(
        name:        UserDefaults.standard.string(forKey: "profile.name")        ?? "Mehmet Arıkaya",
        status:      UserDefaults.standard.string(forKey: "profile.status")      ?? "Stable - Therapy Active",
        age:         UserDefaults.standard.integer(forKey: "profile.age") > 0
                         ? UserDefaults.standard.integer(forKey: "profile.age") : 68,
        bloodType:   UserDefaults.standard.string(forKey: "profile.bloodType")   ?? "A+",
        oxygenLevel: UserDefaults.standard.string(forKey: "profile.oxygenLevel") ?? "94%"
    ) {
        didSet { persistProfile() }
    }

    // Profile Image persistence
    var profileImageData: Data? {
        if let data = UserDefaults.standard.data(forKey: "profile.image") {
            return data
        }
        // Native fallback directly to dedem photo asset
        #if canImport(UIKit)
        return UIImage(named: "dedem<3")?.jpegData(compressionQuality: 0.8)
        #else
        return nil
        #endif
    }

    func saveProfileImage(_ data: Data?) {
        UserDefaults.standard.set(data, forKey: "profile.image")
    }

    private func persistProfile() {
        UserDefaults.standard.set(profile.name,        forKey: "profile.name")
        UserDefaults.standard.set(profile.status,      forKey: "profile.status")
        UserDefaults.standard.set(profile.age,         forKey: "profile.age")
        UserDefaults.standard.set(profile.bloodType,   forKey: "profile.bloodType")
        UserDefaults.standard.set(profile.oxygenLevel, forKey: "profile.oxygenLevel")
    }

    // MARK: - Companion Mode
    var selectedMode: CompanionMode {
        didSet {
            UserDefaults.standard.set(selectedMode.rawValue, forKey: "selectedCompanionMode")
        }
    }

    init() {
        let raw = UserDefaults.standard.string(forKey: "selectedCompanionMode") ?? CompanionMode.empathetic.rawValue
        self.selectedMode = CompanionMode(rawValue: raw) ?? .empathetic
        
        // Initialize Preferences from UserDefaults (default true)
        self.isHapticsEnabled = UserDefaults.standard.object(forKey: "isHapticsEnabled") as? Bool ?? true
        self.isMicrophoneEnabled = UserDefaults.standard.object(forKey: "isMicrophoneEnabled") as? Bool ?? true
    }
    
    // MARK: - App Preferences
    var isHapticsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isHapticsEnabled, forKey: "isHapticsEnabled")
        }
    }
    
    var isMicrophoneEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isMicrophoneEnabled, forKey: "isMicrophoneEnabled")
        }
    }

    // MARK: - Privacy
    var isPrivacyGuardEnabled: Bool = true

    // MARK: - Static data
    let ages = Array(1...120)
    let bloodTypes = ["A+", "A−", "B+", "B−", "AB+", "AB−", "O+", "O−"]
    
    // MARK: - Clinical Data Export
    @MainActor
    func generateClinicalReportURL() -> URL? {
        let dataToExport = ["recent_vitals": HealthSimulator.shared.weeklyData]
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let jsonData = try encoder.encode(dataToExport)
            
            let url = FileManager.default.temporaryDirectory.appendingPathComponent("PulmoFlow_Clinical_Report.json")
            try jsonData.write(to: url)
            
            return url
            
        } catch {
            print("Failed to encode clinical report: \(error.localizedDescription)")
            return nil
        }
    }
}
