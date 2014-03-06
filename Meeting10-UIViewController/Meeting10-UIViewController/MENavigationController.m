//
//  MENavigationController.m
//  Meeting10-UIViewController
//
//  Created by William Towe on 2/19/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "MENavigationController.h"

@interface MENavigationController ()

@end

@implementation MENavigationController

/**
 Take the value returned by our fist child view controller.
 */
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.childViewControllers.firstObject;
}
- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.childViewControllers.firstObject;
}

- (UIModalPresentationStyle)modalPresentationStyle {
    return [self.childViewControllers.firstObject modalPresentationStyle];
}

@end
