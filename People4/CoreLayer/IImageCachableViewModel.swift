import UIKit

protocol IImageCacheableViewModel: class {
    func loadImage(url: URL, completionHandler: ((ImageNetworkResult) -> Void)?)
}

extension IImageCacheableViewModel {
    var imageCache: IImageCacheService {
        return ServiceLocator.getService()
    }
    
    func loadImage(url: URL, completionHandler: ((ImageNetworkResult) -> Void)?) {
        if let cachedVersion = imageCache.getImage(for: url) {
            completionHandler?(.success(image: cachedVersion))
        } else {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                do {
                    let data = try Data(contentsOf: url)
                    if let image = UIImage(data: data) {
                        self?.imageCache.insertImage(image, for: url)
                        completionHandler?(.success(image: image))
                    } else {
                        throw NSError(domain: "Can't decode data to image", code: 0, userInfo: nil)
                    }
                } catch let error {
                    completionHandler?(.failure(error: error))
                }
            }
        }
    }
}
