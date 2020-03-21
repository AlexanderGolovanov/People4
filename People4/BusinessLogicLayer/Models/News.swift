import Foundation
import UIKit

class News: Equatable {
    var title: String
    var link: URL
    var imageURL: URL?
    var date: Date
    var category: String
    var description: String
    
    var cachedImage: UIImage?
    
    init(dto: NewsItemDTO) {
        title = dto.title
        link = dto.link
        imageURL = dto.imageURL
        date = dto.date
        description = dto.description
        category = dto.category
    }
    
    static func == (lhs: News, rhs: News) -> Bool {
        return lhs.link == rhs.link
    }
}
