import UIKit

protocol IImageCacheService: class {
    func insertImage(_ image: UIImage, for url: URL)
    func getImage(for url: URL) -> UIImage?
}

class ImageCacheService: IImageCacheService {
    
    // MARK: - Properties
    
    private let cache: NSCache<NSString, UIImage>
    
    init() {
        cache = .init()
    }
    
    // MARK: - Lifecycle
    
    func insertImage(_ image: UIImage, for url: URL) {
        if getImage(for: url) == nil {
            cache.setObject(image, forKey: NSString(string: url.absoluteString))
        }
    }
    
    func getImage(for url: URL) -> UIImage? {
        return cache.object(forKey: NSString(string: url.absoluteString))
    }
    
    func removeImage(for url: URL) {
        cache.removeObject(forKey: NSString(string: url.absoluteString))
    }
    
}
