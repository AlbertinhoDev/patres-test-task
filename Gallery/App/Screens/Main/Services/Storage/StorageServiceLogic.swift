protocol StorageServiceLogic {
    func createPost(post: Post)
    func fetchAllPosts() -> [Post]
    func fetchPost(postId: Int) -> Post?
    func updatePost(postId: Int, onLike: Bool)
    func deleteAllPostsFromStorage()
}
