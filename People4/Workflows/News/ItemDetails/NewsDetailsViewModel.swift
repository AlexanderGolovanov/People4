import UIKit

protocol INewsDetailsViewModel {
    var title: String { get }
    var date: Date { get }
    var category: String { get }
    var description: String { get }
    var source: String { get }
    
    func loadImage(completionHandler: ((UIImage?) -> Void)?)
    func markAsRead()
    func backAction()
}

protocol INewsDetailsViewModelCoordinable {
    var onReadingNews: ((News) -> Void)? { get }
    var onBackAction: (() -> Void)? { get }
}

class NewsDetailsViewModel: INewsDetailsViewModel, ImageCachableViewModel, INewsDetailsViewModelCoordinable {

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
        return news.source.rawValue
    }
    
    var onReadingNews: ((News) -> Void)?
    var onBackAction: (() -> Void)?
    
    // MARK: - Lifecycle

    init(news: News) {
        self.news = news
    }

    func markAsRead() {
        news.isReaded = true
        newsAggregator.markAsRead(news: news)
        onReadingNews?(news)
    }
    
    func loadImage(completionHandler: ((UIImage?) -> Void)?) {
        guard let url = news.imageURL else {
            completionHandler?(nil)
            return
        }
        loadImage(url: url, completionHandler: completionHandler)
    }
    
    func backAction() {
        onBackAction?()
    }
}
