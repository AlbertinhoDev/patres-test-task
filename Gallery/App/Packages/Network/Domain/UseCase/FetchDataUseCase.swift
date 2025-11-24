import Foundation

protocol FetchDataUseCase {
    func execute(endpoint: Endpoint) async throws -> Data
}

final class FetchDataUseCaseImplement {
    private let repository: FetchDataRepository
    
    init(
        repository: FetchDataRepository
    ) {
        self.repository = repository
    }
}

extension FetchDataUseCaseImplement: FetchDataUseCase {
    func execute(endpoint: Endpoint) async throws -> Data {
        try await repository.fetchData(endpoint: endpoint)
    }
}
