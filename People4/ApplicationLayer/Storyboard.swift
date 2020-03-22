import UIKit

enum Storyboard: String {
    case main = "Main"
    
    func instantiateViewController<T: UIViewController>(withIdentifier: String) -> T {
        let storyBoard = UIStoryboard(name: rawValue, bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: withIdentifier) as! T
    }
}
