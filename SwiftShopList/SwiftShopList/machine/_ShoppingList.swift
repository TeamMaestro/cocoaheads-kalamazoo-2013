// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ShoppingList.swift instead.

import CoreData

enum ShoppingListAttributes: String {
    case createdAt = "createdAt"
    case eid = "eid"
    case name = "name"
}

enum ShoppingListRelationships: String {
    case items = "items"
}

@objc
class _ShoppingList: NSManagedObject {

    // MARK: - Class methods

    class func entityName () -> String {
        return "ShoppingList"
    }

    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _ShoppingList.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged
    var createdAt: NSDate?

    // func validateCreatedAt(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var eid: String?

    // func validateEid(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var name: String?

    // func validateName(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

    @NSManaged
    var items: NSSet

}

extension _ShoppingList {

    func addItems(objects: NSSet) {
        let mutable = self.items.mutableCopy() as NSMutableSet
        mutable.unionSet(objects)
        self.items = mutable.copy() as NSSet
    }

    func removeItems(objects: NSSet) {
        let mutable = self.items.mutableCopy() as NSMutableSet
        mutable.minusSet(objects)
        self.items = mutable.copy() as NSSet
    }

    func addItemsObject(value: Item!) {
        let mutable = self.items.mutableCopy() as NSMutableSet
        mutable.addObject(value)
        self.items = mutable.copy() as NSSet
    }

    func removeItemsObject(value: Item!) {
        let mutable = self.items.mutableCopy() as NSMutableSet
        mutable.removeObject(value)
        self.items = mutable.copy() as NSSet
    }

}
