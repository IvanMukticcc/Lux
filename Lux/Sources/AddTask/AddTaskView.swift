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
                    
                    Toggle("Productive", isOn: viewStore.binding(\.$isTaskProductive))
                    
                    VStack(alignment: .leading) {
                        Text("Priority")
                        Picker("", selection: viewStore.binding(\.$priority)) {
                            ForEach(PriorityType.allCases, id: \.self) { priority in
                                Text(priority.priority)
                                    .tag(priority)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    DatePicker("Due Date", selection: viewStore.binding(\.$dueDate), displayedComponents: [.date, .hourAndMinute])
                    
                    HStack {
                        Spacer()
                        Button {
                            viewStore.send(.addTaskButtonTapped)
                            dissmis()
                        } label: {
                            Text("Add new Task")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        Spacer()
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
