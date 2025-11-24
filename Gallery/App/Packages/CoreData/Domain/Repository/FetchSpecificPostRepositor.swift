import Foundation

protocol FetchSpecificPostRepository {
    func fetchSpecificPost(postId: Int) -> Post?
}
