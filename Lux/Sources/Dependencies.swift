import ComposableArchitecture
import Foundation

extension DependencyValues {
    var taskRepository: TaskCoreDataRepository {
        TaskCoreDataRepository()
    }
}

