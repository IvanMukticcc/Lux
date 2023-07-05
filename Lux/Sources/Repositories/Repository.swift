import Foundation

enum RepositoryError: Error {
    case modelNotFound
    case taskNotFound
}

protocol Repository {
    associatedtype T
    
    func add(_ model: T) async throws -> T
    func get(id: UUID) async throws -> T?
    func getAll() async throws -> [T]
    func update(id: UUID, model: T) async throws -> T
    func delete(id: UUID) async throws
    func remove(at offsets: IndexSet) async throws
    func completedTask(id: UUID, model: T) async throws -> T
}
