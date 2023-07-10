import ComposableArchitecture
import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss)
    var dissmis
    var store: StoreOf<AddTask>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                List {
                    TextField("Enter task description", text: viewStore.binding(\.$description))
                        .inputStyle(.description)
                    
                    VStack(alignment: .leading) {
                        Picker("Category", selection: viewStore.binding(\.$category)) {
                            ForEach(CategoryType.allCases, id: \.self) { category in
                                HStack {
                                    Text(category.categoryName)
                                        .tag(category)
                                    Image(systemName: category.categoryImage)
                                        .imageScale(.small)
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Picker("Priority", selection: viewStore.binding(\.$priority)) {
                            ForEach(PriorityType.allCases, id: \.self) { priority in
                                HStack {
                                    Text(priority.priorityName)
                                        .tag(priority)
                                    Image(systemName: priority.priorityImage)
                                        .imageScale(.small)
                                }
                            }
                        }
                    }
                    DatePicker("Due Date", selection: viewStore.binding(\.$dueDate), displayedComponents: [.date, .hourAndMinute])
                }
                .toolbar {
                    ToolbarItem {
                        Button {
                            viewStore.send(.addTaskButtonTapped)
                            dissmis()
                        } label: {
                            Image(systemName: "checkmark.square")
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dissmis()
                            viewStore.send(.clearForm)
                        } label: {
                            Image(systemName: "xmark.square")
                        }
                    }
                }
            }
        }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView(store: Store(initialState: AddTask.State(), reducer: AddTask()))
    }
}
