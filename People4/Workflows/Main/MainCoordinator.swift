import UIKit

final class MainCoordinator: BaseCoordinator {

    typealias Router = UITabBarController

    // MARK: - Properties

    private let router: Router

    var newsCoordinator: NewsCoordinator!
    
    private lazy var newsModule = makeNewsModule()
    
    // MARK: - Lifecycle

    init(router: Router) {
        self.router = router
    }

    deinit {
        #if DEBUG
        print("💭 deinit NewsCoordinator")
        #endif
    }

    override func start() {
        configureTabs()
    }

    // MARK: - Private
    
    private func makeNewsModule() -> UIViewController {
        let router = UINavigationController()
        router.setNavigationBarHidden(true, animated: false)
        newsCoordinator = NewsCoordinator(router: router)
        newsCoordinator?.completionHandler = { [weak self, weak newsCoordinator] in
            self?.removeDependency(newsCoordinator)
        }
        newsCoordinator.start()
        addDependency(newsCoordinator)
        return router
    }
    
    func configureTabs() {
        newsModule.tabBarItem.title = "NEWS"
        router.viewControllers = [makeNewsModule()]
    }

}

