import CoreData
import Foundation

class TaskCoreDataRepository: TaskRepository {
    private let moc = PersistenceController.shared.container.viewContext
    
    override init() {
        super.init()
        Task {
            try await getAll()
        }
    }
    
    override func add(_ model: TaskModel) async throws -> TaskModel {
        var taskEntity = TaskModelEntity(context: moc)
        TaskMapper.mapToEntity(from: model, entity: &taskEntity)
        
//        try await save()
        if moc.hasChanges {
            try moc.save()
        }
        
        try await getAll()
        return model
    }
    
    override func get(id: UUID) async throws -> TaskModel? {
        let request = TaskModelEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.uuidString)
        
        let result = try moc.fetch(request).map { entity in
            TaskMapper.mapToDomainModel(from: entity)
        }
        
        return result.first
    }
    
    @discardableResult
    override func getAll() async throws -> [TaskModel] {
        let request = TaskModelEntity.fetchRequest()
        
        tasks = try moc.fetch(request).map { entity in
            TaskMapper.mapToDomainModel(from: entity)
        }
        
        return tasks
    }
    
    override func update(id: UUID, model: TaskModel) async throws -> TaskModel {
        let request = TaskModelEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.uuidString)
        
        guard var taskEntity = try moc.fetch(request).first else {
            throw RepositoryError.taskNotFound
        }
        
        TaskMapper.mapToEntity(from: model, entity: &taskEntity)
        try await save()
        
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks[index] = model
        }
        
        return model
    }
    
    override func delete(id: UUID) async throws {
        let request = TaskModelEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.uuidString)

        guard let refuelEntity = try moc.fetch(request).first else {
            throw RepositoryError.modelNotFound
        }

        moc.delete(refuelEntity)
        tasks.removeAll(where: { $0.id == id })

        if moc.hasChanges {
            try moc.save()
        }
        
        try await getAll()
    }
    
    override func remove(at offsets: IndexSet) async throws {
        let items = try moc.fetch(TaskModelEntity.fetchRequest())
        
        for index in offsets {
            let taskToDelete = items[index].id
            tasks.removeAll(where: { $0.id == taskToDelete })
            moc.delete(items[index])
        }
        
        try await save()
        tasks = try await getAll()
    }
    
    private func save() async throws {
        if moc.hasChanges {
            try moc.save()
        }
    }
    
    override func completedTask(id: UUID, model: TaskModel) async throws -> TaskModel {
        let request = TaskModelEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.uuidString)
        
        guard var taskEntity = try moc.fetch(request).first else {
            throw RepositoryError.taskNotFound
        }
        taskEntity.isCompleted = true
        TaskMapper.mapToEntity(from: model, entity: &taskEntity)
        try await save()
        
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks[index] = model
        }
        
        return model
    }

}
