import UIKit

protocol INewsDetailsViewModel {
    var title: String { get }
    var date: Date { get }
    var category: String { get }
    var description: String { get }
    var image: UIImage? { get }
    var source: String { get }
    func markAsRead()
}

protocol INewsDetailsViewModelCoordinable {
    var onReadingNews: ((News) -> Void)? { get }
}

class NewsDetailsViewModel: INewsDetailsViewModel, INewsDetailsViewModelCoordinable {

    // MARK: - Properties
    
    private let news: News
    private let newsAggregator = NewsAggregatorService(sources: .gazeta, .lenta)
    
    var title: String {
        return news.title
    }
    
    var date: Date {
        return news.date
    }
    
    var category: String {
        return news.category
    }
    
    var description: String {
        return news.description
    }
    
    var source: String {
        return news.link.host ?? ""
    }
    
    var image: UIImage? {
        return news.cachedImage
    }
    
    var onReadingNews: ((News) -> Void)?
    
    // MARK: - Lifecycle

    init(news: News) {
        self.news = news
    }

    func markAsRead() {
        news.isReaded = true
        newsAggregator.markAsRead(news: news)
        onReadingNews?(news)
    }
    
    // MARK: - Private

}
