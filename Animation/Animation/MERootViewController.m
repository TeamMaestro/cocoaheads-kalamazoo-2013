//
//  MERootViewController.m
//  Animation
//
//  Created by William Towe on 9/8/13.
//  Copyright (c) 2013 Maestro. All rights reserved.
//

#import "MERootViewController.h"
#import "MEUIViewViewController.h"
#import "MECALayerViewController.h"
#import "MESystemAnimationsViewController.h"
#import "MECustomAnimationsViewController.h"

@interface MERootViewController ()

@end

@implementation MERootViewController

- (id)init {
    if (!(self = [super init]))
        return nil;
    
    [self setViewControllers:@[[[MEUIViewViewController alloc] init],
                               [[MECALayerViewController alloc] init],
                               [[MESystemAnimationsViewController alloc] init],
                               [[MECustomAnimationsViewController alloc] init]]];
    
    [self setSelectedIndex:2];
    
    return self;
}

@end
