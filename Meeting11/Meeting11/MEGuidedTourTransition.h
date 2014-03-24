//
//  MEGuidedTourTransition.h
//  Meeting11
//
//  Created by William Towe on 3/19/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MEGuidedTourTransition : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initForPresenting:(BOOL)presenting;

@end
