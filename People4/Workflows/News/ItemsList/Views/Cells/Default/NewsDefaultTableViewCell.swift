import UIKit

class NewsDefaultTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet private var photoView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    
    // MARK: - Properties

    static let height: CGFloat = 65
    static let identifier = "NewsDefaultTableViewCell"
    
    private var viewModel: INewsTableViewCellViewModel? {
        didSet {
            bindToViewModel()
        }
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
        photoView.image = nil
        titleLabel.text = nil
    }
    
    func configure(with viewModel: INewsTableViewCellViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Private
    
    func bindToViewModel() {
        titleLabel.text = viewModel?.title
        titleLabel.alpha = viewModel?.isReaded == true ? 0.5 : 1.0
        viewModel?.loadImage { [weak self] image in
            DispatchQueue.main.async {
                self?.photoView.image = image
            }
        }
    }
}
