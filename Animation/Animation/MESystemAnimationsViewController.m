//
//  MESystemProvidedAnimationsViewController.m
//  Animation
//
//  Created by William Towe on 9/8/13.
//  Copyright (c) 2013 Maestro. All rights reserved.
//

#import "MESystemAnimationsViewController.h"
#import "MESystemAnimationsContainerViewController.h"

@interface MESystemAnimationsViewController ()

@end

@implementation MESystemAnimationsViewController

- (NSString *)title {
    return NSLocalizedString(@"System", nil);
}

- (id)init {
    if (!(self = [super init]))
        return nil;
    
    [self setViewControllers:@[[[MESystemAnimationsContainerViewController alloc] init]]];
    
    return self;
}

@end
