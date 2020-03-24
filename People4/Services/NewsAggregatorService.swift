import Foundation

protocol INewsAggregatorService {
    func getItems(completionHandler: (([News]?, ILocalizedError?) -> Void)?)
    func markAsRead(news: News)
}

extension INewsAggregatorService {
    func getItems(completionHandler: (([News]?, ILocalizedError?) -> Void)? = nil) {
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
    
    init(sources: INewsService...) {
        self.sources = sources
    }
    
    func getItems(completionHandler: (([News]?, ILocalizedError?) -> Void)?) {
        var news: [News] = []
        sources.forEach { [weak self] newsService in
            guard let `self` = self else { return }
            self.group.enter()
            self.queue.async {
                newsService.getItems { (items, error) in
                    if let error = error {
                        completionHandler?(nil, error)
                        self.group.leave()
                        return
                    }
                    news.append(contentsOf: items ?? [])
                    self.group.leave()
                }
            }
        }
        
        group.notify(queue: queue) { [weak self] in
            guard news.isEmpty == false else { return }
            self?.storage.saveItems(news)
            completionHandler?(self?.storage.getItems(), nil)
        }
    }
    
    func markAsRead(news: News) {
        storage.markAsRead(news: news)
    }
}
