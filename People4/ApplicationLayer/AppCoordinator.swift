import UIKit

final class AppCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    
    let window: UIWindow
    private var mainCoordinator: MainCoordinator?
    
    // MARK: - Lifecycle
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        let router = UINavigationController()
        mainCoordinator = MainCoordinator(router: router)
        mainCoordinator?.completionHandler = { [weak self, weak mainCoordinator] in
            self?.removeDependency(mainCoordinator)
        }
        addDependency(mainCoordinator!)
        mainCoordinator?.start()
        window.rootViewController = router
    }
    

}
