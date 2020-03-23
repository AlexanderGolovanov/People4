import UIKit

class CategoryTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var selectionView: UIView!
    
    // MARK: - Properties

    static let height: CGFloat = 50
    static let reuseIdentifier: String = "CategoryTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionView.layer.cornerRadius = 10.0
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionView.backgroundColor = selected ? .black: .clear
    }
}
