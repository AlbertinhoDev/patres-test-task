import Foundation

protocol FetchPostsUseCase {
    func execute() -> [Post]
}

final class FetchPostsUseCaseImplement {
    private let repository: FetchPostsRepository
    
    init(
        repository: FetchPostsRepository
    ) {
        self.repository = repository
    }
}

extension FetchPostsUseCaseImplement: FetchPostsUseCase {
    func execute() -> [Post] {
        repository.fetchAllPosts()
    }
}
