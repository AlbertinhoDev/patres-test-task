import Foundation

protocol FetchDataRepository {
    func fetchData(endpoint: Endpoint) async throws -> Data
}
