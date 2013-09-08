//
//  MEAppDelegate.m
//  Animation
//
//  Created by William Towe on 9/8/13.
//  Copyright (c) 2013 Maestro. All rights reserved.
//

#import "MEAppDelegate.h"
#import "MERootViewController.h"

@implementation MEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setWindow:[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds]];
    [self.window setRootViewController:[[MERootViewController alloc] init]];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
