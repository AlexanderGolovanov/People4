import Foundation
import CoreData

public class NewsItemDBO: NSManagedObject {
    convenience init(news: News, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "News", in: context)!
        self.init(entity: entity, insertInto: context)
        self.title = news.title
        self.imageURL = news.imageURL
        self.link = news.link
        self.text = news.description
        self.date = news.date
        self.category = news.category
        self.source = news.source.rawValue
        self.isReaded = news.isReaded
    }
    
     static func == (lhs: NewsItemDBO, rhs: NewsItemDBO) -> Bool {
        return lhs.link?.absoluteURL == rhs.link?.absoluteURL
    }
}
