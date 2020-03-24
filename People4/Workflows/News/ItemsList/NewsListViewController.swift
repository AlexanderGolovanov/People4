import UIKit

enum NewsPresentationStyle: Int, CaseIterable {
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
    @IBOutlet private var loadingView: UIView!
    @IBOutlet private var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties

    var viewModel: INewsListViewModel!
    private var style: NewsPresentationStyle = .compact
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindToViewModel()
        viewModel.loadItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Actions

    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        style = NewsPresentationStyle(rawValue: sender.selectedSegmentIndex) ?? .compact
        tableView.reloadSections([0], with: .fade)
    }
    
    @objc func settingsButtonDidTapped() {
        viewModel.settingsAction()
    }
    
    // MARK: - Private

    private func bindToViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .idle, .loading:
                    self?.tableView.isHidden = true
                    self?.loadingView.isHidden = false
                    self?.loadingIndicator.startAnimating()
                case .finished:
                    self?.tableView.isHidden = false
                    self?.loadingView.isHidden = true
                case .error:
                    self?.loadingView.isHidden = true
                }
            }
        }
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
        let defaultCellNib = UINib(nibName: NewsDefaultTableViewCell.identifier, bundle: nil)
        let extendedCellNib = UINib(nibName: NewsExtendedTableViewCell.identifier, bundle: nil)
        tableView.register(defaultCellNib, forCellReuseIdentifier: NewsDefaultTableViewCell.identifier)
        tableView.register(extendedCellNib, forCellReuseIdentifier: NewsExtendedTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        segmentedControl.removeAllSegments()
        NewsPresentationStyle.allCases.forEach { segmentedControl.insertSegment(withTitle: $0.title, at: $0.rawValue, animated: false) }
        segmentedControl.selectedSegmentIndex = NewsPresentationStyle.compact.rawValue
        navigationItem.rightBarButtonItem = .init(title: "Settings", style: .done, target: self, action: #selector(settingsButtonDidTapped))
    }
}

extension NewsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch style {
        case .compact:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsDefaultTableViewCell.identifier) as? NewsDefaultTableViewCell
            if let item = viewModel.itemForIndexPath(indexPath) {
                cell?.configure(with: NewsTableViewCellViewModel(model: item))
            }
            return cell ?? UITableViewCell()
        case .detail:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsExtendedTableViewCell.identifier) as? NewsExtendedTableViewCell
            if let item = viewModel.itemForIndexPath(indexPath) {
                cell?.configure(with: NewsTableViewCellViewModel(model: item))
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
