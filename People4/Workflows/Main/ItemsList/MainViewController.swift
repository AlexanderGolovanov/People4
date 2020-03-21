import UIKit

class MainViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Actions


    // MARK: - Properties

    var viewModel: IMainViewModel!
    private let cache = NSCache<NSString, UIImage>()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindToViewModel()
        viewModel.refreshItems()
    }
    
    // MARK: - Private

    private func bindToViewModel() {
        viewModel.onDataSourceChanged = { [weak self] items in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    private func setupViews() {
        let cellNib = UINib(nibName: MainTableViewCell.reuseIdentifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier) as? MainTableViewCell
        if let item = viewModel.itemForIndexPath(indexPath) {
            cell?.configure(with: MainTableViewCellViewModel(model: item, cache: cache))
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MainTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectItemForIndexPath(indexPath)
    }
}
