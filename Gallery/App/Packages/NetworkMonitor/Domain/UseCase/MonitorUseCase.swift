protocol MonitorUseCase {
    func execute() async -> Bool
}

final class MonitorUseCaseImplement {
    private let repository: MonitorRepository
    
    init(
        repository: MonitorRepository
    ) {
        self.repository = repository
    }
}

extension MonitorUseCaseImplement: MonitorUseCase {
    func execute() async -> Bool {
        await repository.checkConnect()
    }
}
