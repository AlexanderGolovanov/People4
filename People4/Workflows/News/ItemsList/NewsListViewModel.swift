import Foundation

enum RequestableViewModelState { case idle, loading, error, finished }

protocol INewsListViewModel {
    var onRefreshItem: ((IndexPath) -> Void)? { get set }
    var onDataSourceChanged: (([News]) -> Void)? { get set }
    var onStateChanged: ((RequestableViewModelState) -> Void)? { get set }
    func loadItems()
    func numberOfItems() -> Int
    func itemForIndexPath(_ indexPath: IndexPath) -> News?
    func selectItemForIndexPath(_ indexPath: IndexPath)
    func settingsAction()
}

protocol INewsListViewModelCoordinable {
    var onSelectNewsAction: ((News) -> Void)? { get }
    var onSettingsAction: (() -> Void)? { get }
    var onErrorEvent: ((String) -> Void)? { get }
    func newsWasReaded(news: News)
    func settingsWasChanged()
}

class NewsListViewModel: INewsListViewModel, INewsListViewModelCoordinable {

    // MARK: - Properties

    private var items: [News] = []
    private var filteredItems: [News] = []
    private let newsAggregator = NewsAggregatorService(sources: .gazeta, .lenta)
    private let settingsService: ISettingsService = ServiceLocator.getService()
    private var lastSyncDate = Date()
    private var timer: Timer?
    
    private var state: RequestableViewModelState = .idle {
        didSet {
            onStateChanged?(state)
        }
    }
    
    var settings: Settings {
        return settingsService.getSettings()
    }
    
    var onRefreshItem: ((IndexPath) -> Void)?
    var onSelectNewsAction: ((News) -> Void)?
    var onDataSourceChanged: (([News]) -> Void)?
    var onSettingsAction: (() -> Void)?
    var onStateChanged: ((RequestableViewModelState) -> Void)?
    var onErrorEvent: ((String) -> Void)?
    
    // MARK: - IMainViewModel Methods
    
    func loadItems() {
        state = .loading
        refreshItems { [weak self] items in
            DispatchQueue.main.async {
                self?.startTimer(timeInterval: TimeInterval(self?.settings.refreshRate ?? Settings.default.refreshRate))
            }
        }
    }
    
    func numberOfItems() -> Int {
        return filteredItems.count
    }
    
    func itemForIndexPath(_ indexPath: IndexPath) -> News? {
        if !filteredItems.isEmpty && indexPath.row < filteredItems.count {
            return filteredItems[indexPath.row]
        }
        return nil
    }
    
    func selectItemForIndexPath(_ indexPath: IndexPath) {
        if let item = itemForIndexPath(indexPath) {
            onSelectNewsAction?(item)
        }
    }
    
    func newsWasReaded(news: News) {
        if let row = filteredItems.firstIndex(of: news) {
            onRefreshItem?(IndexPath(row: row, section: 0))
        }
    }
    
    func settingsWasChanged() {
        if timer?.timeInterval != TimeInterval(settings.refreshRate) {
            timer?.invalidate()
            DispatchQueue.main.async { [weak self] in
                self?.startTimer(timeInterval: TimeInterval(self?.settings.refreshRate ?? Settings.default.refreshRate))
            }
        }
        filteredItems = filterItems(with: settings)
        onDataSourceChanged?(filteredItems)
    }
    
    func settingsAction() {
        onSettingsAction?()
    }
    
    // MARK: - Private
    
    private func refreshItems(completionHandler: (([News]) -> Void)? = nil) {
        newsAggregator.getItems { [weak self] (items, error) in
            if let error = error {
                self?.state = .error
                DispatchQueue.main.async {
                    self?.onErrorEvent?(error.localizedMessage)
                }
                return
            }
            guard let `self` = self, let items = items else { return }
            self.items = (self.items + items).unique()
            self.filteredItems = self.filterItems(with: self.settings)
            self.onDataSourceChanged?(self.filteredItems)
            self.lastSyncDate = Date()
            self.state = .finished
            completionHandler?(self.filteredItems)
        }
    }
    
    private func startTimer(timeInterval: TimeInterval) {
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(onTimerTick(timer:)), userInfo: nil, repeats: true)
    }
    
    @objc private func onTimerTick(timer: Timer) {
        refreshItems()
    }
    
    private func filterItems(with settings: Settings?) -> [News] {
        if let settings = settings {
            let bottomDate = Calendar.current.date(byAdding: .hour, value: -settings.displayLimit, to: Date()) ?? Date()
            return items.filter { item in
                let categoryExist = item.category == nil ? true : settings.categories.contains(item.category!)
                return item.date >= bottomDate && (settings.categories.isEmpty ? true : categoryExist)
            }
            .sorted(by: { $0.date > $1.date })
        }
        return items
    }
}
