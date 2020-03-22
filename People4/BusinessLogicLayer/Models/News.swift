import Foundation
import UIKit

class News: Equatable {
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
    
    init(dbo: NewsItemDBO) {
        title = dbo.title ?? ""
        link = dbo.link ?? URL(string: "http://onime.com")!
        imageURL = dbo.imageURL
        date = dbo.date ?? Date(timeIntervalSince1970: 0)
        description = dbo.text ?? ""
        category = dbo.category ?? ""
        source = ApiTarget(rawValue: dbo.source ?? "") ?? .none
        isReaded = dbo.isReaded
    }
    
    static func == (lhs: News, rhs: News) -> Bool {
        return lhs.link.absoluteString == rhs.link.absoluteString
    }
}
