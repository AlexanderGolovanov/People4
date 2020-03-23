import UIKit

enum StoryboardScene: String {
    case main = "News"
    case settings = "Settings"
    
    func instantiateViewController<T: UIViewController>(withIdentifier: String) -> T {
        let storyBoard = UIStoryboard(name: rawValue, bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: withIdentifier) as! T
    }
}
