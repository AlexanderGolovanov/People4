import Foundation

protocol ILocalizedError: Error {
    var localizedMessage: String { get }
}

enum ApiError {
    case mappingFailed
    case missingData
    case networkError(message: String)
}

extension ApiError: ILocalizedError {
    var localizedMessage: String {
        switch self {
        case .mappingFailed:
            return "mappingFailed"
        case .missingData:
            return "missingData"
        case .networkError(let message):
            return message
        }
    }
}

enum ApiTarget: String, Codable {
    case lenta = "http://lenta.ru/rss"
    case gazeta = "http://www.gazeta.ru/export/rss/lenta.xml"
    case none
}

enum ApiResponse<T> {
    case onSuccess(items: [T])
    case onError(error: ILocalizedError)
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
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                completionHandler(.onError(error: ApiError.networkError(message: error.localizedDescription)))
                return
            }
            guard let data = data, let `self` = self else {
                completionHandler(.onError(error: ApiError.missingData))
                return
            }
            let parser = RSSParser(data: data, target: self.target)
            parser.parse { items in
                completionHandler(.onSuccess(items: (items as? [T]) ?? []))
            }
        }
        task.resume()
    }
}

