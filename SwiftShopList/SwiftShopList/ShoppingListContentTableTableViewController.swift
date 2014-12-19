//
//  ShoppingListContentTableTableViewController.swift
//  SwiftShopList
//
//  Created by Norm Barnard on 12/4/14.
//  Copyright (c) 2014 Maestro. All rights reserved.
//

import UIKit

class ShoppingListContentTableTableViewController: UITableViewController {
    
    let CellNibName = "ShoppingListTableViewCell"
    var shoppingLists: [ShoppingList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shopping Lists"

        if var allLists = ShoppingList.allInContext(AppController.appController.mainContext!) {
            shoppingLists = allLists
        }
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addButtonTapped:")
        navigationItem.rightBarButtonItem = addButton
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Lists", style: .Plain, target: nil, action: nil)
        
        
        tableView.registerNib(UINib(nibName: CellNibName, bundle: nil), forCellReuseIdentifier: CellNibName)
        tableView.rowHeight = 44.0
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func addButtonTapped(sender: UIBarButtonItem) {
        var newList = ShoppingList(managedObjectContext: AppController.appController.mainContext)
        self.shoppingLists.append(newList)
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.shoppingLists.count-1, inSection: 0)], withRowAnimation: .Automatic)

        var error: NSError? = nil
        var ok = AppController.appController.mainContext!.saveRecursively(&error)
        assert(ok, "Cant save: \(error!.localizedDescription)")
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shoppingLists.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellNibName, forIndexPath: indexPath) as UITableViewCell
        if let shopList = self.shoppingLists[indexPath.row] as ShoppingList? {
            cell.textLabel!.text = shopList.name!
            cell.detailTextLabel!.text = "None"
            cell.detailTextLabel!.text = (shopList.items.count == 0) ? "None" : "\(shopList.items.count)"
        }
        return cell
    }


    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            var sl = shoppingLists[indexPath.row]
            shoppingLists.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            sl.managedObjectContext!.deleteObject(sl)
            AppController.appController.mainContext!.saveRecursively(nil)
        }
    }

    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    // MARK: - table view delegate methods
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var sl = shoppingLists[indexPath.row] as ShoppingList;

        self.navigationController!.pushViewController(ShoppingListItemsTableViewController(aShoppingList: sl), animated: true);
        
    }
    

}
