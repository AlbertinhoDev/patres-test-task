protocol DeleteAllPostsUseCase {
    func execute()
}

final class DeleteAllPostsUseCaseImplement {
    private let repository: DeleteAllPostsRepository
    
    init(
        repository: DeleteAllPostsRepository
    ) {
        self.repository = repository
    }
}

extension DeleteAllPostsUseCaseImplement: DeleteAllPostsUseCase {
    func execute() {
        repository.deleteAllPosts()
    }
}
