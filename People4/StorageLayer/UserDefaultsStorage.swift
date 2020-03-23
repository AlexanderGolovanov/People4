import Foundation

protocol IKeyValueStorage {
    func setValue<T: Codable>(object: T, for key: String)
    func getValue<T: Codable>(for key: String) -> T?
}

class UserDefaultsStorage: IKeyValueStorage {

    private let storage = UserDefaults.standard

    func setValue<T: Codable>(object: T, for key: String) {
        do {
            try storage.set(object: object, forKey: key)
            storage.synchronize()
        } catch let error {
            print("UserDefaultsStorage - \(error)")
        }
    }
    
    func getValue<T: Codable>(for key: String) -> T? {
        return try? storage.get(objectType: T.self, forKey: key)
    }
    
    func setValue(value: Any?, forKey: String) {
        storage.set(value, forKey: forKey)
        storage.synchronize()
    }
    
    func getValue(forKey: String) -> Any? {
        return storage.value(forKey: forKey)
    }
    
    func deleteValue(for key: String) {
        storage.removeObject(forKey: key)
    }
}

public extension UserDefaults {

    /// Set Codable object into UserDefaults
    ///
    /// - Parameters:
    ///   - object: Codable Object
    ///   - forKey: Key string
    /// - Throws: UserDefaults Error
    func set<T: Codable>(object: T, forKey: String) throws {

        let jsonData = try JSONEncoder().encode(object)
        set(jsonData, forKey: forKey)
    }

    /// Get Codable object into UserDefaults
    ///
    /// - Parameters:
    ///   - object: Codable Object
    ///   - forKey: Key string
    /// - Throws: UserDefaults Error
    func get<T: Codable>(objectType: T.Type, forKey: String) throws -> T? {

        guard let result = value(forKey: forKey) as? Data else {
            return nil
        }

        return try JSONDecoder().decode(objectType, from: result)
    }
}
