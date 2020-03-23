import UIKit

class NewsCoordinator: BaseCoordinator {

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
        openNewsModule()
    }

    // MARK: - Private
    
    private func openNewsModule() {
        let vc = makeNewsModule()
        router.pushViewController(vc, animated: false)
    }
    
    private func openNewsDetailsModule(news: News, readingHandler: ((News) -> Void)? = nil) {
        let vc = makeNewsDetailsModule(news: news, readingHandler: readingHandler)
        router.pushViewController(vc, animated: true)
    }
    
    private func makeNewsModule() -> UIViewController {
        let vc: NewsListViewController = StoryboardScene.main.instantiateViewController(withIdentifier: "NewsListViewController")
        let vm = NewsListViewModel()
        vm.onSelectNewsAction = { [weak self, weak vm] news in
            self?.openNewsDetailsModule(news: news) { news in
                vm?.newsWasReaded(news: news)
            }
        }
        vm.onSettingsAction = { [weak self, weak vm] in
            self?.startSettingsFlow {
                vm?.settingsWasChanged()
            }
        }
        vc.viewModel = vm
        return vc
    }
    
    private func makeNewsDetailsModule(news: News, readingHandler: ((News) -> Void)? = nil) -> UIViewController {
        let vc: NewsDetailsViewController = StoryboardScene.main.instantiateViewController(withIdentifier: "NewsDetailsViewController")
        let vm = NewsDetailsViewModel(news: news)
        vm.onReadingNews = readingHandler
        vm.onBackAction = { [weak self] in
            self?.router.popViewController(animated: true)
        }
        vc.viewModel = vm
        return vc
    }
    
    private func startSettingsFlow(settingsChangedHandler: (() -> Void)? = nil) {
        let navVC = UINavigationController()
        let coordinator = SettingsCoordinator(router: navVC)
        coordinator.completionHandler = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
            self?.router.dismiss(animated: true, completion: nil)
        }
        coordinator.onSettingsChanged = settingsChangedHandler
        addDependency(coordinator)
        coordinator.start()
        router.present(navVC, animated: true, completion: nil)
    }

}
