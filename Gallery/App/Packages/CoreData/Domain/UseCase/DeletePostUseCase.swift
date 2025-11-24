import Foundation

protocol DeletePostUseCase {
    func execute(postId: Int)
}

final class DeletePostUseCaseImplement {
    private let repository: DeletePostRepository
    
    init(
        repository: DeletePostRepository
    ) {
        self.repository = repository
    }
}

extension DeletePostUseCaseImplement: DeletePostUseCase {
    func execute(postId: Int) {
        repository.deletePost(postId: postId)
    }
}
