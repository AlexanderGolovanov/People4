import Foundation

enum ApiError {
    case mappingFailed
    case missingData
}

enum ApiTarget: String {
    case lenta = "http://lenta.ru/rss"
    case gazeta = "http://www.gazeta.ru/export/rss/lenta.xml"
}

enum ApiResponse<T> {
    case onSuccess(items: [T])
    case onError(error: ApiError)
}

protocol IApiProvider: class {
    func getItems<T: Codable>(completionHandler: @escaping ((ApiResponse<T>) -> Void))
}

class ApiProvider: IApiProvider {
    
    // MARK: - Properties
    
    private let target: ApiTarget
    
    // MARK: - Lifecycle
    
    init(target: ApiTarget) {
        self.target = target
    }
    
    func getItems<T: Codable>(completionHandler: @escaping ((ApiResponse<T>) -> Void)) {
        let url = URL(string: target.rawValue)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completionHandler(.onError(error: ApiError.missingData))
                return
            }
            let parser = RSSParser(data: data)
            parser.parse { items in
                completionHandler(.onSuccess(items: (items as? [T]) ?? []))
            }
        }
        task.resume()
    }
}

