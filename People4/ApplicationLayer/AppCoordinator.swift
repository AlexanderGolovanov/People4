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
    
    // MARK: - Lifecycle
    
    init(window: UIWindow) {
        self.window = window
        let vc: ViewController = StoryBoard.main.instantiateViewController(withIdentifier: "viewController")
        self.window.rootViewController = vc
    }
}
