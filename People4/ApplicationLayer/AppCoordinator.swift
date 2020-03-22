import UIKit

class AppCoordinator {
    
    // MARK: - Properties
    
    let window: UIWindow
    let router: UINavigationController
    
    // MARK: - Lifecycle
    
    init(window: UIWindow) {
        self.window = window
        self.router = UINavigationController()
        self.window.rootViewController = self.router
        start()
    }
    
    func start() {
        self.router.setViewControllers([makeMainModule()], animated: false)
    }
    
    // MARK: - Private
    
    private func openNewsDetailsModule(news: News, readingHandler: ((News) -> Void)? = nil) {
        let vc = makeNewsDetailsModule(news: news, readingHandler: readingHandler)
        router.pushViewController(vc, animated: true)
    }
    
    private func makeMainModule() -> UIViewController {
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
        vc.viewModel = vm
        return vc
    }
}
