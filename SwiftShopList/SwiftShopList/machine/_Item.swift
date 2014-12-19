// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Item.swift instead.

import CoreData

enum ItemAttributes: String {
    case eid = "eid"
    case gotIt = "gotIt"
    case name = "name"
    case price = "price"
    case quantity = "quantity"
}

enum ItemRelationships: String {
    case shoppingList = "shoppingList"
}

@objc
class _Item: NSManagedObject {

    // MARK: - Class methods

    class func entityName () -> String {
        return "Item"
    }

    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _Item.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged
    var eid: String?

    // func validateEid(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var gotIt: NSNumber?

    // func validateGotIt(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var name: String?

    // func validateName(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var price: NSNumber?

    // func validatePrice(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var quantity: NSNumber?

    // func validateQuantity(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

    @NSManaged
    var shoppingList: ShoppingList?

    // func validateShoppingList(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

}

