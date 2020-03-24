import Foundation
import UIKit

class News: Equatable, Hashable {
    let title: String
    let link: URL
    let imageURL: URL?
    let date: Date
    let category: String?
    let description: String
    let source: ApiTarget
    var isReaded: Bool = false
    
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
            let source = ApiTarget(rawValue: dbo.source ?? "")
        else { return nil}
            
        self.title = title
        self.link = link
        self.imageURL = dbo.imageURL
        self.date = date
        self.description = description.isEmpty ? "Empty description" : description
        self.category = dbo.category
        self.source = source
        self.isReaded = dbo.isReaded
    }
    
    init(title: String, link: URL, imageURL: URL?, date: Date, category: String?, description: String, source: ApiTarget, isReaded: Bool = false) {
        self.title = title
        self.link = link
        self.imageURL = imageURL
        self.date = date
        self.category = category
        self.description = description
        self.source = source
        self.isReaded = isReaded
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(link)
    }
    
    static func == (lhs: News, rhs: News) -> Bool {
        return lhs.link.absoluteString == rhs.link.absoluteString
    }
}
