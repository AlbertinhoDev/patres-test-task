import UIKit

final class AppCoordinator {
    private let window: UIWindow
    private let router: RoutingLogic
    
    init(
        windowScene: UIWindowScene
    ) {
        let navigationController = UINavigationController()
        navigationController.navigationBar.tintColor = .white
        let router = NavigationRouter(navigationController: navigationController)
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.router = router
        self.window = window
    }
}

extension AppCoordinator: CoordinatorLogic {
    func start() {
        let coordinator = MainFlowCoordinator(router: router)
        coordinator.start()
    }
}
