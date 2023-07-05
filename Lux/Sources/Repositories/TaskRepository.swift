import Foundation

class TaskRepository: ObservableObject, Repository {
    func completedTask(id: UUID, model: TaskModel) async throws -> TaskModel {
        guard var task = try await get(id: id) else {
            return model
        }
        
        task.isCompleted = true
        return task
    }
    
    typealias T = TaskModel
    
    @Published
    var tasks: [TaskModel] = []
    
    func add(_ model: TaskModel) async throws -> TaskModel {
        tasks.append(model)
        return model
    }
    
    func get(id: UUID) async throws -> TaskModel? {
        tasks.first(where: { $0.id == id })
    }
    
    func getAll() async throws -> [TaskModel] {
        tasks
    }
    
    func update(id: UUID, model: TaskModel) async throws -> TaskModel {
        guard var task = try await get(id: id) else {
            return model
        }
        
        task.priority = model.priority
        task.taskDescription = model.taskDescription
        task.isProductive = model.isProductive
        
        return task
    }
    
    func delete(id: UUID) async throws {
        tasks.removeAll(where:  { $0.id == id })
    }
    
    func remove(at offsets: IndexSet) async throws {
        tasks.remove(atOffsets: offsets)
    }
 
}
