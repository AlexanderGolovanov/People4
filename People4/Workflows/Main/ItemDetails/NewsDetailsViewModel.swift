import UIKit

protocol INewsDetailsViewModel {
    var title: String { get }
    var date: Date { get }
    var category: String { get }
    var description: String { get }
    var image: UIImage? { get }
    var source: String { get }
}

protocol INewsDetailsViewModelCoordinable {

}

class NewsDetailsViewModel: INewsDetailsViewModel, INewsDetailsViewModelCoordinable {

    // MARK: - Properties
    
    private let news: News
    
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
    
    // MARK: - Lifecycle

    init(news: News) {
        self.news = news
    }


    // MARK: - Private

}
