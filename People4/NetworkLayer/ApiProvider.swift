import Foundation

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

