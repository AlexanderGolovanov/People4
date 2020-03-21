import Foundation

protocol INewsService: class {
    func getItems<T: Codable>(completionHandler: @escaping (([T]?) -> Void))
}

class NewsService: INewsService {
    
    // MARK: - Properties
    
    private let apiProvider: IApiProvider
    
    // MARK: - Lifecycle
    
    init(provider: IApiProvider) {
        self.apiProvider = provider
    }
    
    func getItems<T>(completionHandler: @escaping (([T]?) -> Void)) where T: Codable {
        apiProvider.getItems { (response: ApiResponse<T>) in
            switch response {
            case .onSuccess(let items):
                completionHandler(items)
            case .onError:
                completionHandler(nil)
            }
        }
    }
}
