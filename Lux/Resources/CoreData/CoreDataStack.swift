import CoreData

struct PersistenceController {
    //Singleton for our entire app to use
    static let shared = PersistenceController()
    
    //Storage for Core Data
    let container: NSPersistentContainer
    
    // A test configuration for SwiftUI previews
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)

        return controller
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Lux")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error \(error.localizedDescription)")
            }
        }
    }
}
