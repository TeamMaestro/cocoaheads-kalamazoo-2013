//
//  MEAppDelegate.h
//  Todo
//
//  Created by William Towe on 3/31/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MERootViewController;

@interface MEAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MERootViewController *viewController;

@end
