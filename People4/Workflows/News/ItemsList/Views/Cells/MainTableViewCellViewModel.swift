import UIKit

protocol INewsTableViewCellViewModel {
    var title: String { get }
    var description: String { get }
    var isReaded: Bool { get }
    func loadImage(completionHandler: ((UIImage?) -> Void)?)
}

class NewsTableViewCellViewModel: INewsTableViewCellViewModel, ImageCachableViewModel {
    
    // MARK: - Properties
    
    private let news: News
    
    var title: String {
        return news.title
    }
    
    var description: String {
        return news.description
    }
    
    var isReaded: Bool {
        return news.isReaded
    }
    
    // MARK: - Lifecycle
    
    init(model: News) {
        self.news = model
    }

    func loadImage(completionHandler: ((UIImage?) -> Void)?) {
        return
        guard let url = news.imageURL else {
            completionHandler?(nil)
            return
        }
        loadImage(url: url, completionHandler: completionHandler)
    }
}

