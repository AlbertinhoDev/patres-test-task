import UIKit

final class MainScreenBuilder {}

extension MainScreenBuilder: ScreenBuilderLogic {
    func makeViewController(diContainer: DiContainerLogic) -> UIViewController {
        let viewController = MainViewController()
        let presenter = MainPresenter(apiService: diContainer.apiService, monitorService: diContainer.monitorService, storageService: diContainer.storageService)
        viewController.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}
