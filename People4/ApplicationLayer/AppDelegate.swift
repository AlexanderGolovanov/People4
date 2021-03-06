import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        registerServices()
        appCoordinator = AppCoordinator(window: window!)
        appCoordinator?.start()
        return true
    }
    
    private func registerServices() {
        ServiceLocator.registerService(service: PersistentStorage() as IPersistentStorage)
        ServiceLocator.registerService(service: ImageCacheService() as IImageCacheService)
        ServiceLocator.registerService(service: UserDefaultsStorage() as IKeyValueStorage)
        ServiceLocator.registerService(service: SettingsService() as ISettingsService)
        ServiceLocator.registerService(service: NewsAggregatorService(sources: NewsService(provider: ApiProvider(target: .lenta)), NewsService(provider: ApiProvider(target: .gazeta))) as INewsAggregatorService)
    }
}

