import Foundation

struct VitalSample: Identifiable, Sendable, Codable {
    var id = UUID()
    let date: Date
    let respiratoryRate: Double
    let hrv: Double
    let oxygenLevel: Double
}
