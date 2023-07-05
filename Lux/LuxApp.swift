import SwiftUI

@main
struct LuxApp: App {
    private let taskCoreDataRepository = TaskCoreDataRepository()
    private var taskRepository = TaskRepository()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(taskCoreDataRepository)
        }
    }
}
