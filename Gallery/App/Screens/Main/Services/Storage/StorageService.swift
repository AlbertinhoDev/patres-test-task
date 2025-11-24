import CoreData

final class StorageService {
    private var createPost: CreatePostUseCase?
    private var fetchPosts: FetchPostsUseCase?
    private var fetchPost: FetchSpecificPostUseCase?
    private var deletePost: DeletePostUseCase?
    private var updatePost: UpdatePostUseCase?
    private var deleteAllPosts: DeleteAllPostsUseCase?
    
    init() {
        let context = PersistentController()
        let dataSource = CoreDataManager(context: context.persistentController.viewContext)
        let repository = PostRepositoryImplement(dataSource: dataSource)
        
        createPost = CreatePostUseCaseImplement(repository: repository)
        fetchPosts = FetchPostsUseCaseImplement(repository: repository)
        fetchPost = FetchSpecificPostUseCaseImplement(repository: repository)
        deletePost = DeletePostUseCaseImplement(repository: repository)
        updatePost = UpdatePostUseCaseImplement(repository: repository)
        deleteAllPosts = DeleteAllPostsUseCaseImplement(repository: repository)
    }
}

extension StorageService: StorageServiceLogic {
    func createPost(post: Post) {
        createPost?.execute(post: post)
    }
    
    func fetchAllPosts() -> [Post] {
        fetchPosts?.execute() ?? []
    }
    
    func fetchPost(postId: Int) -> Post? {
        fetchPost?.execute(postId: postId)
    }
    
    func updatePost(postId: Int, onLike: Bool) {
        updatePost?.execute(postId: postId, onLike: onLike)
    }
    
    func deleteAllPostsFromStorage() {
        deleteAllPosts?.execute()
    }
}
