import Foundation

protocol FetchPostsRepository {
    func fetchAllPosts() -> [Post]
}
