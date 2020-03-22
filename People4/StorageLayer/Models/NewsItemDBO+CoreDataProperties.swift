import Foundation
import CoreData

extension NewsItemDBO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsItemDBO> {
        return NSFetchRequest<NewsItemDBO>(entityName: "NewsItemDBO")
    }
    
    @NSManaged public var link: URL?
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var imageURL: URL?
    @NSManaged public var source: String?
    @NSManaged public var category: String?
    @NSManaged public var isReaded: Bool
}
