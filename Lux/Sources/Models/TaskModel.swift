import Foundation
import SwiftUI

struct TaskModel: Equatable {
    static func == (lhs: TaskModel, rhs: TaskModel) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: UUID
    var taskDescription: String
    var isProductive: Bool
    var isCompleted: Bool
    var priority: PriorityType
    var dueDate: Date
    
    static let mock = TaskModel(id: UUID(), taskDescription: "Learn TCA", isProductive: false, isCompleted: true, priority: .high, dueDate: Date())
}

enum PriorityType: Int, CaseIterable, RawRepresentable {
    case high = 0
    case normal = 1
    case low = 2
    
    var priorityColor: Color {
        switch self {
        case .high:
            return .red
        case .normal:
            return .orange
        case .low:
            return .blue
        }
    }
    
    var priority: String {
        switch self {
        case .high:
            return "High"
        case .normal:
            return "Normal"
        case .low:
            return "Low"
        }
    }
    
    var priorityImage: String {
        switch self {
        case .high:
            return "exclamationmark.triangle"
        case .normal:
            return "pencil.and.ruler"
        case .low:
            return "circlebadge"
        }
    }
}
