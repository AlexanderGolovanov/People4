import Foundation

protocol ISettingsService: class {
    func save(settings: Settings)
    func getSettings() -> Settings
}

class SettingsService: ISettingsService {
    
    // MARK: - Properties
    
    private let storage: IKeyValueStorage = ServiceLocator.getService()
    private let key = "SettingsKey"
    
    // MARK: - Lifecycle
    
    func getSettings() -> Settings {
        storage.getValue(for: key) ?? Settings.default
    }
    
    func save(settings: Settings) {
        storage.setValue(object: settings, for: key)
    }
}
