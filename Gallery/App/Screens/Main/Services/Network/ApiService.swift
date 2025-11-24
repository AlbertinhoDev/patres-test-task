import UIKit

final class ApiService {
    private let decoderService: DecoderServiceLogic
    private var networkService: FetchDataUseCase?
    
    init(
        decoderService: DecoderServiceLogic = DecoderService(),
    ) {
        let dataSource = NetworkManager()
        let repository = FetchDataRepositoryImplement(dataSource: dataSource)
        networkService = FetchDataUseCaseImplement(repository: repository)
        self.decoderService = decoderService
    }
}

extension ApiService: ApiServiceLogic {
    func fetchData(endpoint: Endpoint) async throws -> [Response] {
        let data = try await networkService?.execute(endpoint: endpoint)
        guard let data else { return [] }
        let response: [Response] = try decoderService.decode(data: data)
        return response
    }
    
    func fetchImage(endpoint: Endpoint) async throws -> UIImage? {
        let data = try await networkService?.execute(endpoint: endpoint)
        guard let data else { return nil }
        let image = UIImage(data: data)
        return image
    }
}
