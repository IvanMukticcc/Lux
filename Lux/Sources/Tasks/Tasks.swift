import ComposableArchitecture
import UserNotifications
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
        case requestNotificationPermission
        case scheduleNotification
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

            case .addTaskAction(let action):
                switch action {
                case .binding(_):
                    return .none
                case .addTaskButtonTapped:
                    return .task {.scheduleNotification}
                case .clearForm:
                    return .none
                }
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
                return .task { .getTasks }
                
            case .requestNotificationPermission:
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
                return .none
                
            case .scheduleNotification:
                let content = UNMutableNotificationContent()
                content.title = "Clean"
                content.subtitle = "Mark task as completed, or complete it now!"
                content.sound = UNNotificationSound.default
                
                var dateComponents = DateComponents()
                dateComponents.weekday = state.addTaskState.dueDate.get(.day)
                dateComponents.hour = state.addTaskState.dueDate.get(.hour)
                dateComponents.minute = state.addTaskState.dueDate.get(.minute)
                
//                var dateComponents = DateComponents()
//                dateComponents.weekday = 1
//                dateComponents.hour = 14
//                dateComponents.minute = 35
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                let notificationCenter = UNUserNotificationCenter.current()
                notificationCenter.add(request) { (error) in
                   if error != nil {
                       print("Unable to send request \(String(describing: error?.localizedDescription))")
                   }
                }
                return .none
            }
        }
    }
}


extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
