final class NetworkMonitor {
    private let monitorService: MonitorUseCase?
    
    init() {
        let dataSource = MonitorManager()
        let repository = MonitorRepositoryImplement(dataSource: dataSource)
        monitorService = MonitorUseCaseImplement(repository: repository)
    }
}

extension NetworkMonitor: NetworkMonitorLogic {
    func checkConnectToNetwork() async -> Bool {
        guard let monitorService else { return false }
        return await monitorService.execute()
    }
}
