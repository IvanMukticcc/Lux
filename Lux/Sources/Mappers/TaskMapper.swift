import Foundation

struct TaskMapper: DomainModelMapper {
    typealias domainModel = TaskModel
    typealias entityModel = TaskModelEntity
    
    static func mapToDomainModel(from entity: TaskModelEntity) -> TaskModel {
       
        return TaskModel(
            id: entity.id ?? UUID(),
            taskDescription: entity.taskDescription ?? "",
            category: CategoryType(rawValue: Int(entity.category)) ?? .family,
            isCompleted: entity.isCompleted,
            priority: PriorityType(rawValue: Int(entity.priority)) ?? .high,
            dueDate: entity.dueDate ?? Date()
        )
    }
    
    static func mapToEntity(from domain: TaskModel, entity: inout TaskModelEntity) {
        entity.id = domain.id
        entity.taskDescription = domain.taskDescription
        entity.category = Int32(domain.category.rawValue)
        entity.isCompleted = domain.isCompleted
        entity.priority = Int32(domain.priority.rawValue)
        entity.dueDate = domain.dueDate
    }
    
}
