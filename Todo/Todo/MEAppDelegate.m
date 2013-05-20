//
//  MEAppDelegate.m
//  Todo
//
//  Created by William Towe on 3/31/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//

#import "MEAppDelegate.h"

#import "MERootViewController.h"
#import "METodoListViewController.h"

@implementation MEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[MERootViewController alloc] initWithRootViewController:[[METodoListViewController alloc] init]];
    self.window.rootViewController = self.viewController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
