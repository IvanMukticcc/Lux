import SwiftUI

enum PriorityType: Int, CaseIterable, RawRepresentable {
    case low = 0
    case normal = 1
    case high = 2
    case extreme = 3
    
    var priorityColor: Color {
        switch self {
        case .low:
            return .green
        case .normal:
            return .yellow
        case .high:
            return .orange
        case .extreme:
            return .red
        }
    }
    
    var priorityName: String {
        switch self {
        case .low:
            return "Low"
        case .normal:
            return "Normal"
        case .high:
            return "High"
        case .extreme:
            return "Extreme"
        }
    }
    
    var priorityImage: String {
        switch self {
        case .low:
            return "clock.badge.checkmark"
        case .normal:
            return "clock.badge.checkmark"
        case .high:
            return "flame"
        case .extreme:
            return "exclamationmark.triangle"
        }
    }
}
