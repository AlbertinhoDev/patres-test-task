import Foundation

protocol NetworkDataSource {
    func fetchData(endpoint: Endpoint) async throws -> Data
}
