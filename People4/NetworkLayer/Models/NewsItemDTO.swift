import Foundation

struct NewsItemDTO: Codable {
    var title: String
    var link: URL
    var imageURL: URL?
    var category: String?
    var date: Date
    var description: String
    var source: ApiTarget
}
