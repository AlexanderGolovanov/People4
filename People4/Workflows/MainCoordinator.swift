import UIKit

final class MainCoordinator: BaseCoordinator {

    typealias Router = UINavigationController

    // MARK: - Properties

    private let router: Router
    
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
        startMainFlow()
    }

    // MARK: - Private
    
    private func startMainFlow() {
        let coordinator = NewsCoordinator(router: router)
        coordinator.completionHandler = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
        }
        coordinator.start()
        addDependency(coordinator)
    }
}

