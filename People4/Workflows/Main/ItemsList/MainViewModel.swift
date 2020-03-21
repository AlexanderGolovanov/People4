import Foundation

protocol IMainViewModel {
    var onDataSourceChanged: (([News]) -> Void)? { get set }
    func refreshItems()
    func numberOfItems() -> Int
    func itemForIndexPath(_ indexPath: IndexPath) -> News?
    func selectItemForIndexPath(_ indexPath: IndexPath)
}

protocol IMainViewModelCoordinable {
    var onSelectNewsAction: ((News) -> Void)? { get }
}

class MainViewModel: IMainViewModel, IMainViewModelCoordinable {

    // MARK: - Properties

    private var items: [News] = []
    private let newsAggregator = NewsAggregatorService(sources: .gazeta, .lenta)
    
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
    
    // MARK: - Private

}
