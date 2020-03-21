import Foundation

protocol INewsService: class {
    func getItems(completionHandler: @escaping (([News]?) -> Void))
}

class NewsService: INewsService {
    
    // MARK: - Properties
    
    private let apiProvider: IApiProvider
    
    // MARK: - Lifecycle
    
    init(provider: IApiProvider) {
        self.apiProvider = provider
    }
    
    func getItems(completionHandler: @escaping (([News]?) -> Void)) {
        apiProvider.getItems { (response: ApiResponse<NewsItemDTO>) in
            switch response {
            case .onSuccess(let items):
                completionHandler(items.map { News(dto: $0) })
            case .onError:
                completionHandler(nil)
            }
        }
    }
}
