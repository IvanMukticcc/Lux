import SwiftUI

struct TaskRowView: View {
    var task: TaskModel
    
    var body: some View {
            GeometryReader { geo in
                HStack {
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 4)
                            .frame(height: geo.size.height * 0.70)
                            .foregroundColor(task.isProductive ? .green : .red)
                        
                        Image(systemName: task.isProductive ? "heart" : "hand.thumbsdown")
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
            }
            .frame(height: 50)
            .padding(.top, 10)
     }
}

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView(task: TaskModel.mock)
    }
}
