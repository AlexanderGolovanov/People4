import Foundation

class ServiceLocator {
    
    // MARK: - Properties
    
    private static var services = [String: Any]()
    
    // MARK: - Lifecycle
    
    static func registerService<T: Any>(service: T) {
        let key = String(describing: T.self)
        if services[key] == nil {
            services.updateValue(service, forKey: key)
        } else {
            print("Service: \(key) already registered")
        }
    }
    
    static func getService<T: Any>() -> T {
        let key = String(describing: T.self)
        guard let service = services[key] as? T else {
            fatalError("Service: \(key) not registered")
        }
        return service
    }
}
