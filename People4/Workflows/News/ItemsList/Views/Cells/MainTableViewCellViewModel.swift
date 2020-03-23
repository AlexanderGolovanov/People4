import UIKit

protocol INewsTableViewCellViewModel {
    var title: String { get }
    var description: String { get }
    var isReaded: Bool { get }
    func loadImage(completionHandler: ((UIImage) -> Void)?)
}

class NewsTableViewCellViewModel: INewsTableViewCellViewModel {
    
    // MARK: - Properties
    
    private let news: News
    private let imageCache: IImageCacheService = ServiceLocator.getService()
    
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

    func loadImage(completionHandler: ((UIImage) -> Void)?) {
        if let url = news.imageURL, let cachedVersion = imageCache.getImage(for: url) {
            completionHandler?(cachedVersion)
        } else {
            DispatchQueue.global().async { [weak self] in
                guard
                    let url = self?.news.imageURL,
                    let data = try? Data(contentsOf: url),
                    let image = UIImage(data: data)
                    else { return }
                self?.imageCache.insertImage(image, for: url)
                self?.news.cachedImage = image
                completionHandler?(image)
            }
        }
    }
}

