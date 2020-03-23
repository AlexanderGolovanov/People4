import Foundation
import UIKit

class News: Equatable, Hashable {
    var title: String
    var link: URL
    var imageURL: URL?
    var date: Date
    var category: String
    var description: String
    var source: ApiTarget
    var isReaded: Bool = false
    var cachedImage: UIImage?
    
    init(dto: NewsItemDTO) {
        title = dto.title
        link = dto.link
        imageURL = dto.imageURL
        date = dto.date
        description = dto.description
        category = dto.category
        source = dto.source
    }
    
    init?(dbo: NewsItemDBO) {
        guard
            let title = dbo.title,
            let link = dbo.link,
            let date = dbo.date,
            let description = dbo.text,
            let category = dbo.category,
            let source = ApiTarget(rawValue: dbo.source ?? "")
        else { return nil}
            
        self.title = title
        self.link = link
        self.imageURL = dbo.imageURL
        self.date = date
        self.description = dbo.description
        self.category = category
        self.source = source
        self.isReaded = dbo.isReaded
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(link)
    }
    
    static func == (lhs: News, rhs: News) -> Bool {
        return lhs.link.absoluteString == rhs.link.absoluteString
    }
}
