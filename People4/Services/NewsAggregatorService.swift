import Foundation

protocol INewsAggregatorService {
    func getItems(completionHandler: (([News]) -> Void)?)
    func markAsRead(news: News)
}

extension INewsAggregatorService {
    func getItems(completionHandler: (([News]) -> Void)? = nil) {
        return getItems(completionHandler: completionHandler)
    }
}
    
class NewsAggregatorService: INewsAggregatorService {
    
    // MARK: - Properties
    
    private let sources: [INewsService]
    private let storage: IPersistentStorage = ServiceLocator.getService()
    private let queue = DispatchQueue(label: "newsQueue", qos: .utility, attributes: .concurrent)
    private let group = DispatchGroup()
    
    // MARK: - Lifecycle
    
    init(sources: ApiTarget...) {
        self.sources = sources.map { NewsService(provider: ApiProvider(target: $0)) }
    }
    
    func getItems(completionHandler: (([News]) -> Void)?) {
        var news: [News] = []
        sources.forEach { [weak self] newsService in
            guard let `self` = self else { return }
            self.group.enter()
            self.queue.async {
                newsService.getItems { items in
                    news.append(contentsOf: items ?? [])
                    self.group.leave()
                }
            }
        }
        group.notify(queue: queue) { [weak self] in
            self?.storage.saveItems(news)
            completionHandler?(self?.storage.getItems() ?? [])
        }
    }
    
    func markAsRead(news: News) {
        storage.markAsRead(news: news)
    }
}
