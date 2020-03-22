import UIKit

enum NewsPresentationSyle: Int, CaseIterable {
    case compact = 0
    case detail = 1
    
    var title: String {
        switch self {
        case .compact: return "Compact"
        case .detail: return "Detail"
        }
    }
}

class NewsListViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var segmentedControl: UISegmentedControl!
    
    // MARK: - Properties

    var viewModel: INewsListViewModel!
    private let cache = NSCache<NSString, UIImage>()
    private var style: NewsPresentationSyle = .compact
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindToViewModel()
        viewModel.refreshItems()
    }
    
    // MARK: - Actions

    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        style = NewsPresentationSyle(rawValue: sender.selectedSegmentIndex) ?? .compact
        tableView.reloadSections([0], with: .fade)
    }
    
    
    // MARK: - Private

    private func bindToViewModel() {
        viewModel.onDataSourceChanged = { [weak self] items in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.onRefreshItem = { [weak self] indexPath in
            self?.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }

    private func setupViews() {
        let defaultCellNib = UINib(nibName: NewsDefaultTableViewCell.reuseIdentifier, bundle: nil)
        let extendedCellNib = UINib(nibName: NewsExtendedTableViewCell.reuseIdentifier, bundle: nil)
        tableView.register(defaultCellNib, forCellReuseIdentifier: NewsDefaultTableViewCell.reuseIdentifier)
        tableView.register(extendedCellNib, forCellReuseIdentifier: NewsExtendedTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        segmentedControl.removeAllSegments()
        NewsPresentationSyle.allCases.forEach { segmentedControl.insertSegment(withTitle: $0.title, at: $0.rawValue, animated: false) }
        segmentedControl.selectedSegmentIndex = NewsPresentationSyle.compact.rawValue
    }
}

extension NewsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch style {
        case .compact:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsDefaultTableViewCell.reuseIdentifier) as? NewsDefaultTableViewCell
            if let item = viewModel.itemForIndexPath(indexPath) {
                cell?.configure(with: NewsTableViewCellViewModel(model: item, cache: cache))
            }
            return cell ?? UITableViewCell()
        case .detail:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsExtendedTableViewCell.reuseIdentifier) as? NewsExtendedTableViewCell
            if let item = viewModel.itemForIndexPath(indexPath) {
                cell?.configure(with: NewsTableViewCellViewModel(model: item, cache: cache))
            }
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch style {
        case .compact: return NewsDefaultTableViewCell.height
        case .detail: return NewsExtendedTableViewCell.height
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectItemForIndexPath(indexPath)
    }
}
