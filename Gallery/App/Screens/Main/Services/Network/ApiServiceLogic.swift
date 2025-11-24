import UIKit

protocol ApiServiceLogic {
    func fetchData(endpoint: Endpoint) async throws -> [Response]
    func fetchImage(endpoint: Endpoint) async throws -> UIImage?
}
