import Foundation

final class FetchDataRepositoryImplement {
    private let dataSource: NetworkDataSource
    
    init(
        dataSource: NetworkDataSource
    ) {
        self.dataSource = dataSource
    }
}

extension FetchDataRepositoryImplement: FetchDataRepository {
    func fetchData(endpoint: Endpoint) async throws -> Data {
        try await dataSource.fetchData(endpoint: endpoint)
    }
}
