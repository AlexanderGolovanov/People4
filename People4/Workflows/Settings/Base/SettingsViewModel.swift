import Foundation

protocol ISettingsViewModel {
    var settings: Settings { get }
    func numberOfItems() -> Int
    func itemForIndexPath(_ indexPath: IndexPath) -> String?
    func selectItemForIndexPath(_ indexPath: IndexPath)
    func getSelectedIndexes() -> [IndexPath]
    func saveAction(displayLimit: Int, refreshRate: Int, selectedIndexes: [IndexPath])
    func cancelAction()
}

protocol ISettingsViewModelCoordinable {
    var onSaveAction: (() -> Void)? { get }
    var onCancelAction: (() -> Void)? { get }
}

class SettingsViewModel: ISettingsViewModel, ISettingsViewModelCoordinable {

    // MARK: - Properties
    
    private let settingsStorage: IKeyValueStorage = ServiceLocator.getService()
    private let persistentStorage: IPersistentStorage = ServiceLocator.getService()
    
    private var categories: [String] = []
    
    var settings: Settings {
        return settingsStorage.getValue(for: "SettingsKey") ?? Settings.default
    }
    
    var onSaveAction: (() -> Void)?
    var onCancelAction: (() -> Void)?
    
    // MARK: - Lifecycle

    init() {
        categories = persistentStorage.getItems().map { $0.category }.unique().sorted()
    }

    deinit {
        #if DEBUG
        print("💭 deinit SettingsViewModel")
        #endif
    }
    
    func numberOfItems() -> Int {
        return categories.count
    }
    
    func itemForIndexPath(_ indexPath: IndexPath) -> String? {
        if !categories.isEmpty && indexPath.row < categories.count {
            return categories[indexPath.row]
        }
        return nil
    }
    
    func getSelectedIndexes() -> [IndexPath] {
        let saved = settings.categories
        return categories.enumerated().filter { saved.contains($0.element) }.map { IndexPath(row: $0.offset, section: 0) }
    }
    
    func selectItemForIndexPath(_ indexPath: IndexPath) {
        if let item = itemForIndexPath(indexPath) {
            
        }
    }
    
    func saveAction(displayLimit: Int, refreshRate: Int, selectedIndexes: [IndexPath]) {
        let onlyRows = selectedIndexes.map { $0.row }
        let savedCategories = categories.enumerated().filter { onlyRows.contains($0.offset) }.map { $0.element }
        settingsStorage.setValue(object: Settings(displayLimit: displayLimit, refreshRate: refreshRate, categories: savedCategories), for: "SettingsKey")
        onSaveAction?()
    }
    
    func cancelAction() {
        onCancelAction?()
    }
    
    // MARK: - Private

}
