import UIKit

final class NetworkManager {}

extension NetworkManager: NetworkDataSource {
    func fetchData(endpoint: Endpoint) async throws -> Data {
        let (data, httpURLResponse) = try await fetch(endpoint: endpoint)
        
        switch httpURLResponse.statusCode {
        case 200...299:
            return data
        default:
            throw URLError(.badServerResponse)
        }
    }
    
    private func fetch(endpoint: Endpoint) async throws -> (Data, HTTPURLResponse) {
        let urlRequest = endpoint.makeRequest()
        let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
        guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        return (data, httpURLResponse)
    }
}
