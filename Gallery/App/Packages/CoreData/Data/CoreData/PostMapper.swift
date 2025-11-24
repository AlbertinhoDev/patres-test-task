import CoreData
import Foundation

final class PostMapper {
    static func toEntity(_ post: Post, context: NSManagedObjectContext) -> GalleryEntities {
        let entity = GalleryEntities(context: context)
        entity.id = Int16(post.id)
        entity.title = post.title
        entity.body = post.body
        entity.like = post.like
        entity.image = post.image
        return entity
    }
    
    static func toDomain(entity: GalleryEntities) -> Post {
        let id = Int(entity.id)
        let title = entity.title ?? ""
        let body = entity.body ?? ""
        let like = entity.like
        let image = entity.image ?? Data()
        return Post(
            id: id,
            title: title,
            body: body,
            like: like,
            image: image
        )
    }
}
