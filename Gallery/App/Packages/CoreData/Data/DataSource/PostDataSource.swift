import Foundation

protocol PostDataSource {
    func createPost(post: Post)
    func deletePost(postId: Int)
    func fetchPosts() -> [Post]
    func updatePost(postId: Int, onLike: Bool)
    func deleteAllPosts()
    func fetchSpecificPost(postId: Int) -> Post?
}
