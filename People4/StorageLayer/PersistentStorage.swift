import Foundation
import CoreData

protocol IPersistentStorage {
    func getItems() -> [News]
    func saveItems(_ items: [News])
    func markAsRead(news: News)
}

class PersistentStorage: IPersistentStorage {

    // MARK: - Properties
    
    public static let shared: IPersistentStorage = PersistentStorage()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "People4")
        
//        let description = NSPersistentStoreDescription()
//        description.shouldMigrateStoreAutomatically = true
//        description.shouldInferMappingModelAutomatically = true
//        container.persistentStoreDescriptions =  [description]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            print(storeDescription)
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var backgroundContext: NSManagedObjectContext = {
        return persistentContainer.newBackgroundContext()
    }()
    
    func getItems() -> [News] {
        let dbos = getStoredItems()
        return dbos.compactMap { News(dbo: $0) }
    }
    
    func saveItems(_ items: [News]) {
        items.forEach { [weak self] item in
            guard let context = self?.backgroundContext, self?.getStoredItems().first(where: { $0.link?.absoluteString == item.link.absoluteString }) == nil else { return }
            NewsItemDBO(news: item, context: context)
        }
        saveContext()
    }

    func markAsRead(news: News) {
        let item = getStoredItems().first(where: { $0.link?.absoluteURL == news.link.absoluteURL })
        item?.isReaded = news.isReaded
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    
    private func getStoredItems() -> [NewsItemDBO] {
        return (try? backgroundContext.fetch(NewsItemDBO.fetchRequest()) as? [NewsItemDBO]) ?? []
    }
    
    private func saveContext () {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
