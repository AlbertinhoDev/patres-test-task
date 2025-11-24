import Foundation

protocol UpdatePostUseCase {
    func execute(postId: Int, onLike: Bool)
}

final class UpdatePostUseCaseImplement {
    private let repository: UpdatePostRepository
    
    init(
        repository: UpdatePostRepository
    ) {
        self.repository = repository
    }
}

extension UpdatePostUseCaseImplement: UpdatePostUseCase {
    func execute(postId: Int, onLike: Bool) {
        repository.updatePost(postId: postId, onLike: onLike)
    }
}
