import ComposableArchitecture
import SwiftUI

struct TasksEmpty: ReducerProtocol {
    struct State: Equatable {
        var isPresentingAddTask = false
        var addTaskState = AddTask.State()
    }
    
    enum Action: Equatable {
        case addTaskAction(AddTask.Action)
        case isAddNewTaskPresented(isPresented: Bool)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.addTaskState, action: /Action.addTaskAction) {
            AddTask()
        }
        
        Reduce { state, action in
            switch action {
            case .addTaskAction(_):
                return .none
                
            case .isAddNewTaskPresented(let isPresented):
                state.isPresentingAddTask = isPresented
                return .none
            }
        }
    }
}

struct TasksEmptyView: View {
    var store: StoreOf<TasksEmpty>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Text("No ToDos yet, please create first!")
                    .padding(.bottom)
                    .foregroundColor(.gray)
                    .font(.title2)
                
                Button {
                    viewStore.send(.isAddNewTaskPresented(isPresented: true))
                } label: {
                    Image(systemName: "doc.badge.plus")
                        .font(.system(size: 30))
                        .foregroundColor(.primary)
                }
            }
            .sheet(isPresented: viewStore.binding(get: \.isPresentingAddTask, send: TasksEmpty.Action.isAddNewTaskPresented(isPresented:))) {
                AddTaskView(store: Store(initialState: AddTask.State(), reducer: AddTask()))
                    .presentationDetents([.medium])
            }
        }
    }
}

struct TasksEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        TasksEmptyView(store: Store(initialState: TasksEmpty.State(), reducer: TasksEmpty()))
    }
}
