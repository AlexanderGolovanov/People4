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
        router.setNavigationBarHidden(false, animated: true)
        router.pushViewController(vc, animated: true)
    }
    
    private func makeNewsModule() -> UIViewController {
        let vc: NewsListViewController = Storyboard.main.instantiateViewController(withIdentifier: "mainViewController")
        let vm = NewsListViewModel()
        vm.onSelectNewsAction = { [weak self, weak vm] news in
            self?.openNewsDetailsModule(news: news) { news in
                vm?.newsWasReaded(news: news)
            }
        }
        vc.viewModel = vm
        return vc
    }
    
    private func makeNewsDetailsModule(news: News, readingHandler: ((News) -> Void)? = nil) -> UIViewController {
        let vc: NewsDetailsViewController = Storyboard.main.instantiateViewController(withIdentifier: "NewsDetailsViewController")
        let vm = NewsDetailsViewModel(news: news)
        vm.onReadingNews = readingHandler
        vm.onBackAction = { [weak self] in
            self?.router.setNavigationBarHidden(true, animated: true)
            self?.router.popViewController(animated: true)
        }
        vc.viewModel = vm
        return vc
    }

}
