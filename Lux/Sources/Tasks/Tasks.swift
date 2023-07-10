import ComposableArchitecture
import SwiftUI

struct Tasks: ReducerProtocol {
    @Dependency(\.taskRepository)
    var taskRepository
    
    struct State: Equatable {
        var uncompletedTasks: [TaskModel] = []
        var completedTasks: [TaskModel] = []
        @BindingState
        var isShowingAddNewTask = false
        var isTaskCompleted = false
        var addTaskState = AddTask.State()
        var tasksEmptyState = TasksEmpty.State()
    }
    
    enum Action: Equatable, BindableAction {
        case addTaskAction(AddTask.Action)
        case isAddNewTaskPresented(Bool)
        case binding(BindingAction<State>)
        case getTasks
        case tasksFetched(TaskResult<[TaskModel]>)
        case deleteTask(IndexSet)
        case addCompletedTask(TaskModel)
        case taskCompleted(TaskResult<TaskModel>)
        case tasksEmptyAction(TasksEmpty.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.addTaskState, action: /Action.addTaskAction) {
            AddTask()
        }
        
        Scope(state: \.tasksEmptyState, action: /Action.tasksEmptyAction) {
            TasksEmpty()
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
                state.uncompletedTasks = tasks.filter { $0.isCompleted == false }
                state.completedTasks = tasks.filter { $0.isCompleted == true }
                return .none
                
            case let .tasksFetched(.failure(error)):
                print("Error occured while fetching tasks: \(error.localizedDescription)")
                return .none
                
            case .deleteTask(let indexSet):
                Task {
                    try await taskRepository.remove(at: indexSet)
                }
                return .task {.getTasks}
                
            case .addCompletedTask(let task):
                if var task = state.uncompletedTasks.first(where: {$0 == task}) {
                    task.isCompleted = true
                    let updatedTask = task
                    return .task {
                        await .taskCompleted(TaskResult {
                            try await taskRepository.update(id: updatedTask.id, model: updatedTask)
                        })
                    }
                }
                return .none
                
            case .taskCompleted:
                return .task {
                    .getTasks
                }
                
            case .tasksEmptyAction(let action):
                switch action {
                case .addTaskAction(_):
                    return .none
                    
                case .isAddNewTaskPresented(isPresented: let isPresented):
                    state.isShowingAddNewTask = isPresented
                }
                return .none
            }
        }
    }
}
