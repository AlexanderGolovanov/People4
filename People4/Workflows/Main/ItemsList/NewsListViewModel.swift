import Foundation

protocol INewsListViewModel {
    var onRefreshItem: ((IndexPath) -> Void)? { get set }
    var onDataSourceChanged: (([News]) -> Void)? { get set }
    func refreshItems()
    func numberOfItems() -> Int
    func itemForIndexPath(_ indexPath: IndexPath) -> News?
    func selectItemForIndexPath(_ indexPath: IndexPath)
}

protocol INewsListViewModelCoordinable {
    var onSelectNewsAction: ((News) -> Void)? { get }
    func newsWasReaded(news: News)
}

class NewsListViewModel: INewsListViewModel, INewsListViewModelCoordinable {

    // MARK: - Properties

    private var items: [News] = []
    private let newsAggregator = NewsAggregatorService(sources: .gazeta, .lenta)
    private var lastSyncDate = Date()
    
    var onRefreshItem: ((IndexPath) -> Void)?
    var onSelectNewsAction: ((News) -> Void)?
    var onDataSourceChanged: (([News]) -> Void)?
    
    // MARK: - IMainViewModel Methods
    
    func refreshItems() {
        newsAggregator.getItems { [weak self] items in
            guard let `self` = self else { return }
            self.items = (self.items + items).sorted(by: { $0.date > $1.date })
            self.onDataSourceChanged?(self.items)
        }
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func itemForIndexPath(_ indexPath: IndexPath) -> News? {
        if !items.isEmpty && indexPath.row < items.count {
            return items[indexPath.row]
        }
        return nil
    }
    
    func selectItemForIndexPath(_ indexPath: IndexPath) {
        if let item = itemForIndexPath(indexPath) {
            onSelectNewsAction?(item)
        }
    }
    
    func newsWasReaded(news: News) {
        if let row = items.firstIndex(of: news) {
            onRefreshItem?(IndexPath(row: row, section: 0))
        }
    }
    
    // MARK: - Private

}
