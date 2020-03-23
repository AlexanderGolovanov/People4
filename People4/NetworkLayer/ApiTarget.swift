import Foundation

enum ApiTarget: String, Codable {
    case lenta = "http://lenta.ru/rss"
    case gazeta = "http://www.gazeta.ru/export/rss/lenta.xml"
    case none
}
