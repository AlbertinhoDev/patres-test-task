import Foundation

protocol CreatePostUseCase {
    func execute(post: Post)
}

final class CreatePostUseCaseImplement {
    private let repository: CreatePostRepository
    
    init(
        repository: CreatePostRepository
    ) {
        self.repository = repository
    }
}

extension CreatePostUseCaseImplement: CreatePostUseCase {
    func execute(post: Post) {
        repository.createPost(post: post)
    }
}
