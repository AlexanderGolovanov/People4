import Foundation
import CoreData


extension NewsItemDBO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsItemDBO> {
        return NSFetchRequest<NewsItemDBO>(entityName: "NewsItemDBO")
    }

    @NSManaged public var link: String?
    @NSManaged public var text: String?
    @NSManaged public var title: String?

}
