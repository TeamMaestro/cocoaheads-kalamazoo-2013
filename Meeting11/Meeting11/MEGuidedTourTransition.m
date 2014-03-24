//
//  MEGuidedTourTransition.m
//  Meeting11
//
//  Created by William Towe on 3/19/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "MEGuidedTourTransition.h"

@interface MEGuidedTourTransition ()
@property (assign,nonatomic,getter = isPresenting) BOOL presenting;
@end

@implementation MEGuidedTourTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    if (self.isPresenting) {
        [containerView addSubview:fromViewController.view];
        [containerView addSubview:toViewController.view];
        
        [toViewController.view setFrame:containerView.bounds];
        [toViewController.view setTransform:CGAffineTransformMakeScale(3, 3)];
        [toViewController.view setAlpha:0];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [toViewController.view setAlpha:1];
            [toViewController.view setTransform:CGAffineTransformIdentity];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    else {
        [containerView addSubview:toViewController.view];
        [containerView addSubview:fromViewController.view];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [fromViewController.view setAlpha:0];
            [fromViewController.view setTransform:CGAffineTransformMakeScale(3, 3)];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

- (instancetype)initForPresenting:(BOOL)presenting; {
    if (!(self = [super init]))
        return nil;
    
    [self setPresenting:presenting];
    
    return self;
}

@end
