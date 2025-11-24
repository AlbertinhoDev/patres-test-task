import CoreData
import Foundation

final class PersistentController {
    var persistentController: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GalleryDataBase")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}
