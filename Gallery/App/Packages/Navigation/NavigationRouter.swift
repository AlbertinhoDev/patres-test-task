import UIKit

final class NavigationRouter {
    private let navigationController: UINavigationController
    
    init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }
}

extension NavigationRouter: RoutingLogic {
    func setRoot(viewController: UIViewController, animated: Bool) {
        navigationController.setViewControllers([viewController], animated: animated)
    }
}
