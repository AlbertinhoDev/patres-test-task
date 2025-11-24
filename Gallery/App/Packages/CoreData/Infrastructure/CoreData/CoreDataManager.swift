import CoreData

final class CoreDataManager {
    private let context: NSManagedObjectContext
    
    init(
        context: NSManagedObjectContext
    ) {
        self.context = context
    }
}

extension CoreDataManager: PostDataSource {
    func createPost(post: Post) {
        _ = PostMapper.toEntity(post, context: context)
        try? context.save()
    }
    
    func deletePost(postId: Int) {
        let req = GalleryEntities.fetchRequest()
        req.predicate = NSPredicate(format: "id == %d", Int16(postId))
        
        if let posts = try? context.fetch(req), let resultPost = posts.first {
            context.delete(resultPost)
            try? context.save()
        }
    }
    
    func deleteAllPosts() {
        let req: NSFetchRequest<NSFetchRequestResult> = GalleryEntities.fetchRequest()
        let deleteReq: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: req)
        
        do {
            try context.execute(deleteReq)
        } catch {
            print("Failed to delete all posts: \(error)")
        }
    }
    
    func fetchPosts() -> [Post] {
        let req = GalleryEntities.fetchRequest()
        
        guard let posts = try? context.fetch(req) else {
            return []
        }
        return posts.map { PostMapper.toDomain(entity: $0) }
    }
    
    func fetchSpecificPost(postId: Int) -> Post? {
        let req = GalleryEntities.fetchRequest()
        req.predicate = NSPredicate(format: "id == %d", Int16(postId))
        
        guard let entity = try? context.fetch(req).first else {
            return nil
        }
        
        return PostMapper.toDomain(entity: entity)
    }
    
    func updatePost(postId: Int, onLike: Bool) {
        let req = GalleryEntities.fetchRequest()
        req.predicate = NSPredicate(format: "id == %d", Int16(postId))
        
        if let posts = try? context.fetch(req), let resultPost = posts.first {
            resultPost.like = onLike
            try? context.save()
        }
    }
}
