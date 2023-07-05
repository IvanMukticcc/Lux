import ComposableArchitecture
import SwiftUI

struct AddTask: ReducerProtocol {
    @Dependency(\.taskRepository)
    var taskRepository
    
    struct State: Equatable {
        @BindingState
        var description = ""
        @BindingState
        var priority: PriorityType = .high
        @BindingState
        var isTaskProductive = false
        var isCompleted = false
        var task: TaskModel?
        @BindingState
        var dueDate: Date = Date()
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case addTaskButtonTapped
        case clearForm
    }
    
    var body: some ReducerProtocol<State, Action>{
        BindingReducer()
        
        Reduce{ state, action in
            switch action {
                
            case .binding(_):
                return .none
            case .addTaskButtonTapped:
                let task = TaskModel(id: UUID(), taskDescription: state.description, isProductive: state.isTaskProductive, isCompleted: state.isCompleted, priority: state.priority, dueDate: state.dueDate)
                Task {
                    try await taskRepository.add(task)
                }
                return .task { .clearForm }
            case .clearForm:
                state.description = ""
                return .none
            }
        }
    }
}
