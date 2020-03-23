import Foundation
import CoreData

protocol IPersistentStorage: class {
    func getItems() -> [News]
    func saveItems(_ items: [News])
    func markAsRead(news: News)
}

class PersistentStorage: IPersistentStorage {

    // MARK: - Properties
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "People4")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var backgroundContext: NSManagedObjectContext = {
        return persistentContainer.newBackgroundContext()
    }()
    
    // MARK: - Lifecycle
    
    func getItems() -> [News] {
        let dbos = getStoredItems()
        return dbos.compactMap { News(dbo: $0) }
    }
    
    func saveItems(_ items: [News]) {
        items.forEach { [weak self] item in
            guard self?.getStoredItems().first(where: { $0.link?.absoluteString == item.link.absoluteString }) == nil else { return }
            self?.saveObject(news: item)
        }
        saveContext()
    }

    func markAsRead(news: News) {
        let item = getStoredItems().first(where: { $0.link?.absoluteURL == news.link.absoluteURL })
        item?.isReaded = news.isReaded
        saveContext()
    }
    
    // MARK: - Private
    
    private func saveObject(news: News) {
        guard let entity = NSEntityDescription.entity(forEntityName: "News", in: backgroundContext) else { return }
        let dto = NewsItemDBO(entity: entity, insertInto: backgroundContext)
        dto.title = news.title
        dto.imageURL = news.imageURL
        dto.link = news.link
        dto.text = news.description
        dto.date = news.date
        dto.category = news.category
        dto.source = news.source.rawValue
        dto.isReaded = news.isReaded
    }
    
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
