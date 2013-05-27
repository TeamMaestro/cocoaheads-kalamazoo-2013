//
//  METoDoItemEditViewController.h
//  Todo
//
//  Created by Norm Barnard on 5/27/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MEEditViewControllerProtocol.h"

@interface METoDoItemEditViewController : UIViewController

@property (nonatomic, weak) id <MEEditViewControllerDelegate> delegate;
- (id)initWithItemId:(NSManagedObjectID *)itemId managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
