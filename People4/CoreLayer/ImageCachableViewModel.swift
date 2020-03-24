import UIKit

protocol ImageCachableViewModel: class {
    func loadImage(completionHandler: ((UIImage?) -> Void)?)
}

extension ImageCachableViewModel {
    var imageCache: IImageCacheService {
        return ServiceLocator.getService()
    }
    
    func loadImage(url: URL, completionHandler: ((UIImage) -> Void)?) {
        if let cachedVersion = imageCache.getImage(for: url) {
            completionHandler?(cachedVersion)
        } else {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard
                    let data = try? Data(contentsOf: url),
                    let image = UIImage(data: data)
                    else { return }
                self?.imageCache.insertImage(image, for: url)
                completionHandler?(image)
            }
        }
    }
}
