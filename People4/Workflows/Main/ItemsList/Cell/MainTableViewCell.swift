import UIKit

class MainTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet private var photoView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    
    
    // MARK: - Properties

    static let height: CGFloat = 65
    static let reuseIdentifier = "MainTableViewCell"
    
    private var viewModel: IMainTableViewCellViewModel? {
        didSet {
            bindToViewModel()
        }
    }

    func configure(with viewModel: IMainTableViewCellViewModel) {
        self.viewModel = viewModel
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
        photoView.image = nil
    }
    
    // MARK: - Private
    
    func bindToViewModel() {
        titleLabel.text = viewModel?.title
        viewModel?.loadImage { [weak self] image in
            DispatchQueue.main.async {
                self?.photoView.image = image
            }
        }
    }
}

protocol IMainTableViewCellViewModel {
    var title: String { get }
    var description: String { get }
    func loadImage(completionHandler: ((UIImage) -> Void)?)
}

class MainTableViewCellViewModel: IMainTableViewCellViewModel {
    
    // MARK: - Properties
    
    private let news: News
    private let cache: NSCache<NSString, UIImage>
    
    var title: String {
        return news.title
    }
    
    var description: String {
        return news.description
    }
    
    // MARK: - Lifecycle
    
    init(model: News, cache: NSCache<NSString, UIImage>) {
        self.news = model
        self.cache = cache
    }

    func loadImage(completionHandler: ((UIImage) -> Void)?) {
        if let url = news.imageURL, let cachedVersion = cache.object(forKey: NSString(string: url.absoluteString)) {
            completionHandler?(cachedVersion)
        } else {
            DispatchQueue.global().async { [weak self] in
                guard
                    let url = self?.news.imageURL,
                    let data = try? Data(contentsOf: url),
                    let image = UIImage(data: data)
                    else { return }
                self?.cache.setObject(image, forKey: NSString(string: url.absoluteString))
                self?.news.cachedImage = image
                completionHandler?(image)
            }
        }
    }
}
