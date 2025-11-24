import Foundation

final class MainFlowCoordinator {
    private let router: RoutingLogic
    private let screenBuilder: ScreenBuilderLogic
    private let diContainer: DiContainerLogic
    
    init(
        router: RoutingLogic,
        screenBuilder: ScreenBuilderLogic = MainScreenBuilder(),
        diContainer: DiContainerLogic = DiContainer()
    ) {
        self.router = router
        self.screenBuilder = screenBuilder
        self.diContainer = diContainer
    }
}

extension MainFlowCoordinator: CoordinatorLogic {
    func start() {
        let viewController = screenBuilder.makeViewController(diContainer: diContainer)
        router.setRoot(viewController: viewController, animated: true)
    }
}
