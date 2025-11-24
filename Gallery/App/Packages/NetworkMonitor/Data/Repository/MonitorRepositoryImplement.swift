final class MonitorRepositoryImplement {
    private let dataSource: MonitorDataSource
    
    init(
        dataSource: MonitorDataSource
    ) {
        self.dataSource = dataSource
    }
}

extension MonitorRepositoryImplement: MonitorRepository {
    func checkConnect() async -> Bool {
        await dataSource.checkConnect()
    }
}
