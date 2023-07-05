import Foundation

struct TaskMapper: DomainModelMapper {
    typealias domainModel = TaskModel
    typealias entityModel = TaskModelEntity
    
    static func mapToDomainModel(from entity: TaskModelEntity) -> TaskModel {
       
        return TaskModel(
            id: entity.id ?? UUID(),
            taskDescription: entity.taskDescription ?? "",
            isProductive: entity.isProductive,
            isCompleted: entity.isCompleted,
            priority: PriorityType(rawValue: Int(entity.priority)) ?? .high,
            dueDate: entity.dueDate ?? Date()
        )
    }
    
    static func mapToEntity(from domain: TaskModel, entity: inout TaskModelEntity) {
        entity.id = domain.id
        entity.taskDescription = domain.taskDescription
        entity.isProductive = domain.isProductive
        entity.isCompleted = domain.isCompleted
        entity.priority = Int32(domain.priority.rawValue)
        entity.dueDate = domain.dueDate
    }
    
}
