import UIKit

extension UIViewController {
    func displayAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func displayRetryAlert(with message: String, completionHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Retry", style: .default, handler: { _ in completionHandler?() }))
        present(alert, animated: true, completion: nil)
    }
}
