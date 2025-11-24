final class DiContainer: DiContainerLogic {
    var apiService: ApiServiceLogic
    var monitorService: NetworkMonitorLogic
    var storageService: StorageServiceLogic
    
    init(
        apiService: ApiServiceLogic = ApiService(),
        monitorService: NetworkMonitorLogic = NetworkMonitor(),
        storageService: StorageServiceLogic = StorageService()
    ) {
        self.apiService = apiService
        self.monitorService = monitorService
        self.storageService = storageService
    }
}
