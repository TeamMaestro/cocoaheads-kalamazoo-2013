//
//  MEAppDelegate.m
//  Meeting10-UIViewController
//
//  Created by William Towe on 2/19/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "MEAppDelegate.h"
#import "MEViewController.h"
#import "MENavigationController.h"

@implementation MEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /**
     Create a new window, set its background color and root view controller, then make it visible.
     */
    [self setWindow:[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window setRootViewController:[[MENavigationController alloc] initWithRootViewController:[[MEViewController alloc] init]]];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
