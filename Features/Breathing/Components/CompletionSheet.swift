import SwiftUI

struct CompletionSheet: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    @EnvironmentObject private var tabRouter: TabRouter
    @AppStorage("selectedCompanionMode") private var companionModeRaw: String = CompanionMode.empathetic.rawValue
    
    private var currentMode: CompanionMode {
        CompanionMode(rawValue: companionModeRaw) ?? .empathetic
    }
    
    let exerciseTitle: String
    var onDismiss: () -> Void
    
    private var exerciseType: BreathingExercise? {
        BreathingExercise.allCases.first(where: { $0.rawValue == exerciseTitle })
    }
    
    private var isRescue: Bool { exerciseType == .rescue }
    private var isHuff: Bool { exerciseType == .huff }
    
    private var themeColor: Color {
        if isRescue { return .teal } // Calming recovery color, overriding the card's alarming orange.
        return exerciseType?.color ?? currentMode.color
    }
    
    private var themeIcon: String {
        if isRescue { return "checkmark.shield.fill" }
        if isHuff { return "waveform.and.mic" }
        return "wind"
    }
    
    private var heroSubtitleText: String {
        if isRescue { return "SAFE RECOVERY" }
        return currentMode == .clinical ? "Session Logged" : "Session Complete"
    }
    
    private var heroHeadlineText: String {
        if isRescue { return "Breathe Easy." }
        if isHuff {
            switch currentMode {
            case .clinical: return "Acoustic Logged"
            case .motivating: return "Lungs Cleared!"
            case .empathetic: return "Deep Breath Done"
            }
        } else {
            switch currentMode {
            case .clinical: return "Therapy Recorded"
            case .motivating: return "Fantastic Flow!"
            case .empathetic: return "Amazing Job!"
            }
        }
    }
    
    private var infoCardTitle: String {
        if isRescue { return "WHAT TO DO NEXT" }
        return currentMode == .clinical ? "CLINICAL REGIMEN" : "WHY THIS MATTERS"
    }
    
    private var infoCardBody: String {
        if isRescue {
            return "Are you feeling better? If your shortness of breath persists, please notify a family member or seek medical services. If you feel stable, try standing up slowly and taking a short, gentle walk."
        }
        
        switch currentMode {
        case .clinical:
            if isHuff {
                return "Huff coughing effectively mobilizes secretions. We prescribe this acoustic measurement 3 times daily to track lung congestion accurately."
            } else {
                return "Consistent adherence is required to monitor changes in your pulmonary capacity. We prescribe performing these pursed-lip maneuvers 3–5 times strictly daily."
            }
        case .motivating:
            if isHuff {
                return "You crushed that Huff Challenge! Doing this daily clears out the bad air and congestion, making room for fresh oxygen. Keep pushing!"
            } else {
                return "You crushed it! Keep this momentum going. Completing your pursed-lip exercises 3-5 times a day is how you win back your breath."
            }
        case .empathetic:
            if isHuff {
                return "You've successfully helped your lungs clear out trapped air. We gently recommend practicing the Huff technique whenever you feel congested."
            } else {
                return "Consistency is your best friend when managing shortness of breath. We gently recommend practicing 3–5 times a day to maintain your airway flexibility."
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header / Hero Section
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(themeColor.opacity(colorScheme == .dark ? 0.15 : 0.1))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: themeIcon)
                        .font(.system(.title, weight: .bold))
                        .foregroundColor(themeColor)
                }
                .padding(.top, 40)
                
                VStack(spacing: 8) {
                    Text(heroSubtitleText)
                        .font(.system(.footnote, design: .rounded, weight: .black))
                        .foregroundColor(themeColor)
                    
                    Text(heroHeadlineText)
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text(isRescue ? "You have successfully completed the **\(exerciseTitle)**." : (currentMode == .clinical ? "You just completed the **\(exerciseTitle)** protocol." : "You just finished **\(exerciseTitle)**."))
                        .font(.system(.body, design: .rounded, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 24)
            
            Spacer(minLength: 40)
            
            // Info Card Section (Matching ExerciseDetailOverlay style)
            // Info Card Section
            VStack(alignment: .leading, spacing: 8) {
                Text(infoCardTitle)
                    .font(.system(.footnote, design: .rounded, weight: .black))
                    .foregroundColor(themeColor)
                
                Text(infoCardBody)
                    .font(.system(.body, design: .rounded, weight: .medium))
                    .foregroundColor(.primary.opacity(0.9))
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(themeColor.opacity(colorScheme == .dark ? 0.15 : 0.08))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding(.horizontal, 24)
            
            Spacer(minLength: 40)
            
            // Action Section
            VStack(spacing: 24) {
                Text(isRescue ? "Your heart rate and breathing should be stabilizing." : "Now, take a moment to reflect.")
                    .font(.system(.callout, design: .rounded, weight: .medium))
                    .foregroundColor(.secondary)
                
                Button(action: {
                    onDismiss()
                    if !isRescue {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            let calendar = Calendar.current
                            var components = DateComponents()
                            components.year = calendar.component(.year, from: .now)
                            components.month = 3
                            components.day = 2
                            let targetDate = calendar.date(from: components)
                            
                            tabRouter.navigateTo(tab: 2, targetDate: targetDate) // Check-In
                        }
                    }
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: isRescue ? "checkmark.circle.fill" : "signature")
                            .font(.system(.title3, weight: .semibold))
                        Text(isRescue ? "I'm Feeling Better" : "Log Today's Pledge")
                            .font(.system(.title3, design: .rounded, weight: .bold))
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(isRescue ? "I'm Feeling Better" : "Log Today's Pledge")
                    .accessibilityAddTraits(.isButton)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(themeColor)
                    .clipShape(Capsule())
                    .shadow(color: themeColor.opacity(0.3), radius: 10, x: 0, y: 5)
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .frame(width: 520, height: 600)
        .background {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(colorScheme == .dark ? 0.35 : 0.18), radius: 40, x: 0, y: 20)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .stroke(themeColor.opacity(0.35), lineWidth: 1.5)
        )
    }
}
