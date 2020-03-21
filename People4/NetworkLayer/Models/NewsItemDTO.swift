import Foundation

struct NewsItemDTO: Codable {
    var title: String
    var link: URL
    var imageURL: URL?
    var date: Date
    var description: String
}
