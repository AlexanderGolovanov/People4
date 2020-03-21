import Foundation

protocol INewsAggregatorService {
    func getItems()
}

class NewsAggregatorService: INewsAggregatorService {
    
    // MARK: - Properties
    
    private let sources: [INewsService]
    
    // MARK: - Lifecycle
    
    init(sources: ApiTarget...) {
        self.sources = sources.map { NewsService(provider: ApiProvider(target: $0)) }
    }
    
    func getItems() {
        
    }
}
