import Foundation

final class PostRepositoryImplement {
    private let dataSource: PostDataSource
    
    init(
        dataSource: PostDataSource
    ) {
        self.dataSource = dataSource
    }
}

extension PostRepositoryImplement: CreatePostRepository {
    func createPost(post: Post) {
        dataSource.createPost(post: post)
    }
}

extension PostRepositoryImplement: DeletePostRepository {
    func deletePost(postId: Int) {
        dataSource.deletePost(postId: postId)
    }
}

extension PostRepositoryImplement: FetchPostsRepository {
    func fetchAllPosts() -> [Post] {
        dataSource.fetchPosts()
    }
}

extension PostRepositoryImplement: FetchSpecificPostRepository {
    func fetchSpecificPost(postId: Int) -> Post? {
        dataSource.fetchSpecificPost(postId: postId)
    }
}

extension PostRepositoryImplement: UpdatePostRepository {
    func updatePost(postId: Int, onLike: Bool) {
        dataSource.updatePost(postId: postId, onLike: onLike)
    }
}

extension PostRepositoryImplement: DeleteAllPostsRepository {
    func deleteAllPosts() {
        dataSource.deleteAllPosts()
    }
}

