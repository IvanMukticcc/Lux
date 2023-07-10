import ComposableArchitecture
import SwiftUI

struct TasksView: View {
    var store: StoreOf<Tasks>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                Group {
                    if viewStore.completedTasks.isEmpty && viewStore.uncompletedTasks.isEmpty {
                        TasksEmptyView(store: store.scope(state: \.tasksEmptyState, action: Tasks.Action.tasksEmptyAction))
                    } else {
                        List {
                            Section("UNCOMPLETED") {
                                ForEach(viewStore.uncompletedTasks, id: \.id) { task in
                                    TaskRowView(task: task)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            viewStore.send(.addCompletedTask(task))
                                        }
                                        .tag(UUID())
                                }
                                .onDelete { indices in
                                    viewStore.send(.deleteTask(indices))
                                }
                            }
                            
                            Section("COMPLETED") {
                                ForEach(viewStore.completedTasks, id: \.id) { task in
                                    TaskRowView(task: task)
                                        .tag(UUID())
                                }
                                .onDelete { indices in
                                    viewStore.send(.deleteTask(indices))
                                }
                            }
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
                        .presentationDetents([.medium])
                }
                .onAppear {
                    viewStore.send(.getTasks)
                    viewStore.send(.requestNotificationPermission)
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
