import UIKit

class NewsExtendedTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet private var photoView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    // MARK: - Properties

    static let height: CGFloat = 100
    static let identifier = "NewsExtendedTableViewCell"
    
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
        descriptionLabel.text = nil
    }
    
    func configure(with viewModel: INewsTableViewCellViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Private
    
    func bindToViewModel() {
        titleLabel.text = viewModel?.title
        titleLabel.alpha = viewModel?.isReaded == true ? 0.5 : 1.0
        descriptionLabel.text = viewModel?.description
        descriptionLabel.alpha = viewModel?.isReaded == true ? 0.5 : 1.0
        viewModel?.loadImage { [weak self] image in
            DispatchQueue.main.async {
                self?.photoView.image = image
            }
        }
    }
}
