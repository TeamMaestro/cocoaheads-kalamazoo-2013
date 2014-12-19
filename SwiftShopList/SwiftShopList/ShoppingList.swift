import CoreData
import Foundation

@objc(ShoppingList)
class ShoppingList: _ShoppingList {

    
    class func allInContext(context: NSManagedObjectContext) -> [ShoppingList]? {
        
        var error: NSError? = nil
        var results = context.fetchEntitiesNamed(ShoppingList.entityName(), sortDescriptors: [ NSSortDescriptor(key: ShoppingListAttributes.createdAt.rawValue, ascending: false) ], predicate: nil, error: &error)
        return results?.map({ (obj: AnyObject) -> ShoppingList in
            return obj as ShoppingList
        });
    }
    
    lazy var defaultDateFormatter: NSDateFormatter = {
       
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE, MMM d, yy"
        return dateFormatter
    }()

    override func awakeFromInsert() {
        super.awakeFromInsert()
        createdAt = NSDate()
        name = self.defaultDateFormatter.stringFromDate(self.createdAt!)
        eid = NSUUID().UUIDString
    }
    
    func allItems() -> [Item] {
        let unsorted =  self.items.allObjects.map({ (obj: AnyObject) -> Item in
            return obj as Item
        }) as [Item]
        
        return sorted(unsorted, { (item1: Item?, item2: Item?) -> Bool in
            let bool1 = (item1!.gotIt == nil) ? false : item1!.gotIt!.boolValue
            let bool2 = (item2!.gotIt == nil) ? false : item2!.gotIt!.boolValue
            return bool2 && bool1 == false
        })
        
    }

}
