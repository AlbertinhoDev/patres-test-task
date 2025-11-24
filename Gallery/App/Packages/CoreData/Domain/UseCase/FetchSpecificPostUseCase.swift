import Foundation

protocol FetchSpecificPostUseCase {
    func execute(postId: Int) -> Post?
}

final class FetchSpecificPostUseCaseImplement {
    private let repository: FetchSpecificPostRepository
    
    init(
        repository: FetchSpecificPostRepository
    ) {
        self.repository = repository
    }
}

extension FetchSpecificPostUseCaseImplement: FetchSpecificPostUseCase {
    func execute(postId: Int) -> Post? {
        repository.fetchSpecificPost(postId: postId)
    }
}
