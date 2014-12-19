//
//  ShoppingListNavigationControllerViewController.swift
//  SwiftShopList
//
//  Created by Norm Barnard on 12/4/14.
//  Copyright (c) 2014 Maestro. All rights reserved.
//

import UIKit

class ShoppingListNavigationControllerViewController: UINavigationController {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init() {
        super.init(nibName: nil, bundle: nil)
        viewControllers = [ ShoppingListContentTableTableViewController() ]
    }
    
}
