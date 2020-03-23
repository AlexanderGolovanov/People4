import Foundation

struct Settings: Codable {
    let displayLimit: Int
    let refreshRate: Int
    let categories: [String]
    
    static var `default`: Settings {
        return Settings(displayLimit: 6, refreshRate: 5, categories: [])
    }
}
