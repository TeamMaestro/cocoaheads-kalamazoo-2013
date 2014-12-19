//
//  ShoppingListItemsTableViewController.swift
//  SwiftShopList
//
//  Created by Norm Barnard on 12/5/14.
//  Copyright (c) 2014 Maestro. All rights reserved.
//

import CoreData
import UIKit

class ShoppingListItemsTableViewController: UITableViewController {

    let ItemCellNibName = "ItemTableViewCell"
    var shoppingList: ShoppingList?
    var itemDataSource:  [Item] = []
    var priceFormatter: NSNumberFormatter?
    var indexPathToRefreshAfterEdit: NSIndexPath?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(aShoppingList: ShoppingList) {
        super.init(nibName: nil, bundle: nil)
        self.shoppingList = aShoppingList;
        self.priceFormatter = NSNumberFormatter()
        self.priceFormatter!.numberStyle = .CurrencyStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let sl = self.shoppingList {
            self.title = sl.name
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addButtonTapped:")
        
        itemDataSource = shoppingList!.allItems()
        
        tableView.registerNib(UINib(nibName: ItemCellNibName, bundle: nil), forCellReuseIdentifier: ItemCellNibName)
        tableView.rowHeight = 44.0
        
        
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: button actions
    
    func addButtonTapped(sender: UIBarButtonItem) {
        
        var newItem = Item(managedObjectContext: shoppingList!.managedObjectContext)
        shoppingList!.addItemsObject(newItem)
        itemDataSource.insert(newItem, atIndex: 0)
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
        shoppingList!.managedObjectContext?.saveRecursively(nil)
    }
    
    // MARK: - tableView delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = itemDataSource[indexPath.row]
        self.navigationController!.pushViewController(ItemDetailViewController(item: item), animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sl = self.shoppingList {
            return itemDataSource.count
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ItemCellNibName, forIndexPath: indexPath) as UITableViewCell
        cell.textLabel!.text = nil
        cell.detailTextLabel!.text = nil
        if let item = itemDataSource[indexPath.row] as Item? {
            cell.textLabel!.text = item.name ?? "New Item"
            let price = item.price ?? 0
            let quantity = item.quantity ?? 1
            if (price.doubleValue > 0) && (quantity.integerValue > 0) {
                var prettyPrice = priceFormatter!.stringFromNumber(item.price!)
                cell.detailTextLabel!.text = "\(quantity) @ \(prettyPrice!)"
            }
        }
        return cell
    }


    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // nop
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {

        let editAction = UITableViewRowAction(style: .Normal, title: "Got It!") { (action, indexPath) -> Void in
            var item = self.itemDataSource[indexPath.row]
            item.gotIt = true
            let lastPath = NSIndexPath(forRow: self.itemDataSource.count-1, inSection: 0)
            self.itemDataSource.removeAtIndex(indexPath.row)
            self.itemDataSource.append(item)
            tableView.editing = false
            let cell = tableView.cellForRowAtIndexPath(indexPath)!
            cell.textLabel!.textColor = UIColor.lightGrayColor()
            tableView.moveRowAtIndexPath(indexPath, toIndexPath: lastPath)
            item.managedObjectContext!.saveRecursively(nil)
        }
        editAction.backgroundColor = UIColor(red: 0.19, green: 0.60, blue: 1.0, alpha: 1.0)
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete") { (action, indexPath) -> Void in
            var item = self.itemDataSource[indexPath.row]
            self.itemDataSource.removeAtIndex(indexPath.row)
            if let moc = item.managedObjectContext as NSManagedObjectContext? {
                moc.deleteObject(item)
                moc.saveRecursively(nil)
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        var item = self.itemDataSource[indexPath.row] as Item?
        if let gotIt = item?.gotIt?.boolValue {
            return [deleteAction]
        }
        return [deleteAction, editAction]
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {        
        let item = self.itemDataSource[indexPath.row] as Item?
        if let gotIt = item?.gotIt?.boolValue {
            cell.textLabel!.textColor = UIColor.lightGrayColor()
        } else {
            cell.textLabel!.textColor = UIColor.blackColor()
        }
    }

    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

}
