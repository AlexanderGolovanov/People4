import UIKit

class NewsDetailsViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var categoryLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var sourceLabel: UILabel!
    
    // MARK: - Actions


    // MARK: - Properties

    var viewModel: INewsDetailsViewModel!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindToViewModel()
    }


    // MARK: - Private

    private func bindToViewModel() {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        categoryLabel.text = viewModel.category
        dateLabel.text = getDateFormatter().string(from: viewModel.date)
        imageView.image = viewModel.image
        sourceLabel.text = viewModel.source
    }

    private func setupViews() {

    }
    
    private func getDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd.MM.yyyy"
        return formatter
    }
}
