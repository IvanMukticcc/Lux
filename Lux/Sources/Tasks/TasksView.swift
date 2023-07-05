import ComposableArchitecture
import SwiftUI

struct TasksView: View {
    var store: StoreOf<Tasks>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                List {
                    Section {
                        ForEach(viewStore.tasks.filter { !$0.isCompleted }, id: \.id) { task in
                            TaskRowView(task: task)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    viewStore.send(.addCompletedTask(task))
                                }
                        }
                        .onDelete { indices in
                            viewStore.send(.deleteTask(indices))
                        }
                    }
                    Section {
                        ForEach(viewStore.tasks.filter { $0.isCompleted }, id: \.id) { task in
                            TaskRowView(task: task)
                        }
                        .onDelete { indices in
                            viewStore.send(.deleteTask(indices))
                        }
                    }
                }
                .navigationTitle("ToDo")
                .toolbar {
                    ToolbarItem {
                        Button {
                            viewStore.send(.isAddNewTaskPresented(true))
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: viewStore.binding(\.$isShowingAddNewTask)) {
                    AddTaskView(store: store.scope(state: \.addTaskState, action: Tasks.Action.addTaskAction))
                }
                .onAppear {
                    viewStore.send(.getTasks)
                }
                .onChange(of: viewStore.isShowingAddNewTask) { _ in
                    viewStore.send(.getTasks)
                }
            }
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView(store: Store(initialState: Tasks.State(), reducer: Tasks()))
    }
}
