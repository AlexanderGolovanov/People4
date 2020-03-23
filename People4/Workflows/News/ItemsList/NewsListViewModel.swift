import Foundation

protocol INewsListViewModel {
    var onRefreshItem: ((IndexPath) -> Void)? { get set }
    var onDataSourceChanged: (([News]) -> Void)? { get set }
    func refreshItems()
    func numberOfItems() -> Int
    func itemForIndexPath(_ indexPath: IndexPath) -> News?
    func selectItemForIndexPath(_ indexPath: IndexPath)
    func settingsAction()
}

protocol INewsListViewModelCoordinable {
    var onSelectNewsAction: ((News) -> Void)? { get }
    var onSettingsAction: (() -> Void)? { get }
    func newsWasReaded(news: News)
    func settingsWasChanged()
}

class NewsListViewModel: INewsListViewModel, INewsListViewModelCoordinable {

    // MARK: - Properties

    private var items: [News] = []
    private var filteredItems: [News] = []
    private let newsAggregator = NewsAggregatorService(sources: .gazeta, .lenta)
    private let settingsStorage: IKeyValueStorage = ServiceLocator.getService()
    private var lastSyncDate = Date()
    private var timer: Timer?
    
    var settings: Settings? {
        return settingsStorage.getValue(for: "SettingsKey")
    }
    
    var onRefreshItem: ((IndexPath) -> Void)?
    var onSelectNewsAction: ((News) -> Void)?
    var onDataSourceChanged: (([News]) -> Void)?
    var onSettingsAction: (() -> Void)?
    
    // MARK: - IMainViewModel Methods
    
    func refreshItems() {
        getItems { [weak self] items in
            DispatchQueue.main.async {
                self?.startTimer(timeInterval: TimeInterval(self?.settings?.refreshRate ?? Settings.default.refreshRate))
            }
        }
    }
    
    private func getItems(completion: (([News]) -> Void)? = nil) {
        newsAggregator.getItems { [weak self] items in
            print("refresh")
            guard let `self` = self else { return }
            self.items = (self.items + items).unique()
            self.filteredItems = self.filterItems(with: self.settings)
            self.onDataSourceChanged?(self.filteredItems)
            self.lastSyncDate = Date()
            completion?(self.filteredItems)
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
        if timer?.timeInterval != TimeInterval(settings?.refreshRate ?? Settings.default.refreshRate) {
            print("TIMER WAS INVALIDATED")
            timer?.invalidate()
            DispatchQueue.main.async { [weak self] in
                self?.startTimer(timeInterval: TimeInterval(self?.settings?.refreshRate ?? Settings.default.refreshRate))
            }
        }
        filteredItems = filterItems(with: settings)
        onDataSourceChanged?(filteredItems)
    }
    
    func settingsAction() {
        onSettingsAction?()
    }
    
    // MARK: - Private

    private func startTimer(timeInterval: TimeInterval) {
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(onTimerTick(timer:)), userInfo: nil, repeats: true)
    }
    
    @objc private func onTimerTick(timer: Timer) {
        getItems()
    }
    
    private func filterItems(with settings: Settings?) -> [News] {
        if let settings = settings {
             let bottomDate = Calendar.current.date(byAdding: .hour, value: -settings.displayLimit, to: Date()) ?? Date()
            return items.filter { $0.date >= bottomDate && (settings.categories.isEmpty ? true : settings.categories.contains($0.category)) }.sorted(by: { $0.date > $1.date })
        }
        return items
    }
}
