
import CoreData

@objc(Item)

class Item: _Item {

    override func awakeFromInsert() {
        super.awakeFromInsert()
        self.eid = NSUUID().UUIDString
    }
    
    func formattedPrice() -> String {
        
        var numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        return numberFormatter.stringFromNumber(self.price ?? 0.0)!
        
    }
    
    
}
