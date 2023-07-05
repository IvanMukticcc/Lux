import ComposableArchitecture
import SwiftUI

struct Tasks: ReducerProtocol {
    @Dependency(\.taskRepository)
    var taskRepository
    
    struct State: Equatable {
        var tasks: [TaskModel] = []
        var completedTasks: [TaskModel] = []
        @BindingState
        var isShowingAddNewTask = false
        var isTaskCompleted = false
        
        var addTaskState = AddTask.State()
    }
    
    enum Action: Equatable, BindableAction {
        case addTaskAction(AddTask.Action)
        case isAddNewTaskPresented(Bool)
        case binding(BindingAction<State>)
        case getTasks
        case tasksFetched(TaskResult<[TaskModel]>)
        case deleteTask(IndexSet)
        case addCompletedTask(TaskModel)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.addTaskState, action: /Action.addTaskAction) {
            AddTask()
        }
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .isAddNewTaskPresented(let isPresented):
                state.isShowingAddNewTask = isPresented
                return .none

            case .addTaskAction:
                return .none
            case .binding(_):
                return .none
                
            case .getTasks:
                return .task {
                    await .tasksFetched(TaskResult {
                        try await self.taskRepository.getAll()
                    })
                }
                
            case let .tasksFetched(.success(tasks)):
                state.tasks = tasks
                return .none
                
            case let .tasksFetched(.failure(error)):
                print("Error occured while fetching tasks: \(error.localizedDescription)")
                return .none
                
            case .deleteTask(let indexSet):
                Task {
                    try await taskRepository.remove(at: indexSet)
                }
                return .none
                
            case .addCompletedTask(let task):
                if let task = state.tasks.first(where: {$0 == task}) {
                    Task {
                        try await taskRepository.completedTask(id: task.id, model: task)
                    }
                }
                    
                return .task { .getTasks }
            }
        }
    }
}
