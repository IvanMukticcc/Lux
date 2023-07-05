import ComposableArchitecture
import SwiftUI


struct ContentView: View {
    
    
    var body: some View {
                TasksView(store: Store(initialState: Tasks.State(), reducer: Tasks()))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

