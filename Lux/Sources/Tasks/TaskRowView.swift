import SwiftUI

struct TaskRowView: View {
    var task: TaskModel
    
    var body: some View {
                HStack {
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 4)
                            .frame(height: 40)
                            .foregroundColor(task.category.categoryColor)
                        
                        Image(systemName: task.category.categoryImage)
                                .bold()
                       
                    }
                    .padding(.trailing)
                    VStack(alignment: .leading) {
                        Text(task.taskDescription)
                            .font(.headline)
                            .padding(.bottom, 5)
                        HStack {
                            Text("\(task.dueDate.formatted(date: .abbreviated, time: .shortened))")
                                .font(.subheadline)
                        }
                    }
                    Spacer()
                    Image(systemName: task.priority.priorityImage)
                        .bold()
                        .foregroundColor(task.priority.priorityColor)
                }
                .frame(height: 50)
     }
}

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView(task: TaskModel.mock)
    }
}
