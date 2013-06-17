//
//  MEEditViewControllerProtocol.h
//  Todo
//
//  Created by Norm Barnard on 5/26/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@protocol MEEditViewControllerDelegate <NSObject>

@optional
// called when the users requested that their edits be saved
- (void)editViewController:(UIViewController *)editViewController didSaveObject:(NSManagedObject *)object;
// called otherwise
- (void)editViewController:(UIViewController *)editViewController didCancelSaveForObject:(NSManagedObject *)object;

@end
