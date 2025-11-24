import Foundation

protocol UpdatePostRepository {
    func updatePost(postId: Int, onLike: Bool)
}
