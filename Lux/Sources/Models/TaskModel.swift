import Foundation
import SwiftUI

struct TaskModel: Equatable {
    static func == (lhs: TaskModel, rhs: TaskModel) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: UUID
    var taskDescription: String
    var category: CategoryType
    var isCompleted: Bool
    var priority: PriorityType
    var dueDate: Date
    
    static let mock = TaskModel(id: UUID(), taskDescription: "Learn TCA", category: .hobby, isCompleted: true, priority: .high, dueDate: Date())
}
