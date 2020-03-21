import Foundation
import CoreData


public class NewsItemDBO: NSManagedObject {
    convenience init(title: String, link: String, text: String) {
        self.init()
        self.title = title
        self.link = link
        self.text = text
    }
}
