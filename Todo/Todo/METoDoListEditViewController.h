//
//  METoDoListEditViewController.h
//  Todo
//
//  Created by Norm Barnard on 5/26/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//

#import "MEEditViewControllerProtocol.h"
#import <UIKit/UIKit.h>

@interface METoDoListEditViewController : UIViewController

@property (nonatomic, weak) id <MEEditViewControllerDelegate> delegate;

- (id)initWithToDoListId:(NSManagedObjectID *)listID managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
