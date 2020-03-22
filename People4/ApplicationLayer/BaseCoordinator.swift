import UIKit

protocol ICoordinator: class {
    var completionHandler: (() -> Void)? {get set}
    func start()
}

class BaseCoordinator: ICoordinator {

    var childCoordinators: [ICoordinator] = []
    var completionHandler: (() -> Void)?
    
    func start() {
        
    }
    
    func addDependency(_ coordinator: ICoordinator) {
        for element in childCoordinators where element === coordinator {
            return
        }
        childCoordinators.append(coordinator)
    }
    
    func removeDependency(_ coordinator: ICoordinator?) {
        guard childCoordinators.isEmpty == false, let coordinator = coordinator else { return }
        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }
}
