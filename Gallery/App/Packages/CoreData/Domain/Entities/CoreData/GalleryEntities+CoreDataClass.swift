public import CoreData
public import Foundation

public typealias GalleryEntitiesCoreDataClassSet = NSSet

@objc(GalleryEntities)
public class GalleryEntities: NSManagedObject {}

extension GalleryEntities {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<GalleryEntities> {
        return NSFetchRequest<GalleryEntities>(entityName: "GalleryEntities")
    }

    @NSManaged public var body: String?
    @NSManaged public var id: Int16
    @NSManaged public var image: Data?
    @NSManaged public var like: Bool
    @NSManaged public var title: String?
}

extension GalleryEntities : Identifiable {}
