import UIKit

class SettingsCoordinator: BaseCoordinator {

    typealias Router = UINavigationController

    // MARK: - Properties

    private let router: Router
    public var onSettingsChanged: (() -> Void)?
    
    // MARK: - Lifecycle

    init(router: Router) {
        self.router = router
    }

    deinit {
        #if DEBUG
        print("💭 deinit SettingsCoordinator")
        #endif
    }

    override func start() {
        let vc = makeSettingsModule()
        router.modalPresentationStyle = .overCurrentContext
        router.modalTransitionStyle = .crossDissolve
        router.pushViewController(vc, animated: false)
    }

    // MARK: - Make modules

    private func makeSettingsModule() -> UIViewController {
        let vc: SettingsViewController = StoryboardScene.settings.instantiateViewController(withIdentifier: "SettingsViewController")
        let vm = SettingsViewModel()
        vm.onSaveAction = { [weak self] in
            self?.onSettingsChanged?()
            self?.completionHandler?()
        }
        vm.onCancelAction = { [weak self] in
            self?.completionHandler?()
        }
        vc.viewModel = vm
        return vc
    }

    // MARK: - Private


}
