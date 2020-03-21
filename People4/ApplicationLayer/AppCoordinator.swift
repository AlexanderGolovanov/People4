import UIKit

enum StoryBoard: String {
    case main = "Main"
    
    func instantiateViewController<T: UIViewController>(withIdentifier: String) -> T {
        let storyBoard = UIStoryboard(name: rawValue, bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: withIdentifier) as! T
    }
}

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
    
    private func openNewsDetailsModule(news: News) {
        let vc = makeNewsDetailsModule(news: news)
        router.pushViewController(vc, animated: true)
    }
    
    private func makeMainModule() -> UIViewController {
        let vc: MainViewController = StoryBoard.main.instantiateViewController(withIdentifier: "mainViewController")
        let vm = MainViewModel()
        vm.onSelectNewsAction = { [weak self] news in
            self?.openNewsDetailsModule(news: news)
        }
        vc.viewModel = vm
        return vc
    }
    
    private func makeNewsDetailsModule(news: News) -> UIViewController {
        let vc: NewsDetailsViewController = StoryBoard.main.instantiateViewController(withIdentifier: "NewsDetailsViewController")
        let vm = NewsDetailsViewModel(news: news)
        vc.viewModel = vm
        return vc
    }
}
