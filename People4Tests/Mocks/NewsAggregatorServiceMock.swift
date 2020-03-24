import Foundation
@testable import People4

class NewsAggregatorServiceMock: INewsAggregatorService {
    
    private let service: INewsService
    
    init(newsService: INewsService) {
        self.service = newsService
    }
    
    func getItems(completionHandler: (([News]?, ILocalizedError?) -> Void)? = nil) {
        service.getItems(completionHandler: { (items, error) in
            completionHandler?(items, error)
        })
    }
    
    func markAsRead(news: News) {
        
    }
}
