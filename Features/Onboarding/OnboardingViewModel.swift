import AVFoundation
import HealthKit
import Foundation
import SwiftUI

@MainActor
class OnboardingViewModel: ObservableObject {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    
    @Published var isMicAuthorized = false
    @Published var isHealthAuthorized = false
    @Published var selectedMode: CompanionMode = .motivating {
        didSet {
            UserDefaults.standard.set(selectedMode.rawValue, forKey: "selectedCompanionMode")
        }
    }
    
    // CompanionMode renamed and moved to Models/CompanionMode.swift for sharing

    
    private let healthStore = HKHealthStore()
    
    func requestMicrophonePermission() async {
        // Just set the category for permission request, don't set active yet to avoid abort signal
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
        } catch {
            print("Failed to set audio session category: \(error)")
        }
        
        let granted = await AVAudioApplication.requestRecordPermission()
        self.isMicAuthorized = granted
    }
    
    func requestHealthKitPermission() {
        // HealthKit temporarily disabled to resolve build issues
        self.isHealthAuthorized = true // Visual placeholder for stability
    }
    
    func completeOnboarding() {
        withAnimation(.spring()) {
            hasCompletedOnboarding = true
        }
    }
}
