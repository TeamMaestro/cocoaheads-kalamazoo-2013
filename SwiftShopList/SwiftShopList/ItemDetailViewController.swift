//
//  ItemDetailViewController.swift
//  SwiftShopList
//
//  Created by Norm Barnard on 12/5/14.
//  Copyright (c) 2014 Maestro. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    
    var item: Item?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(item anItem: Item) {
        self.item = anItem
        super.init(nibName: "ItemDetailView", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = UIRectEdge.allZeros
        self.nameField.text = self.item?.name ?? ""
        self.quantityField.text = self.item?.quantity?.stringValue ?? "1"
        self.priceField.text = self.item?.price?.stringValue ?? "0.00"
        if let gotIt = self.item?.gotIt?.boolValue {
            self.nameField.enabled = false
            self.quantityField.enabled = false
            self.priceField.enabled = false
        }
        navigationItem.title = self.item?.name ?? "New Item"
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let hasChanges = self.item?.managedObjectContext?.hasChanges.boolValue {
            self.item?.managedObjectContext?.saveRecursively(nil)
        }
    }
    
    // MARK: textfield delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        switch textField {
            
        case self.nameField:
            self.item?.name = textField.text
        case self.quantityField:
            var qty = textField.text?.toInt()
            self.item?.quantity = qty
        case self.priceField:
            var str = NSString(string: textField.text)
            self.item?.price = str.doubleValue
            println("set price")
        default:
            assertionFailure("Unknown text field")
        }
        self.item?.managedObjectContext?.saveRecursively(nil)
        return true
    }
    
}
