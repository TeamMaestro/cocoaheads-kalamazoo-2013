//
//  MESystemAnimationsContainerViewController.m
//  Animation
//
//  Created by William Towe on 9/8/13.
//  Copyright (c) 2013 Maestro. All rights reserved.
//

#import "MESystemAnimationsContainerViewController.h"
#import "MESystemAnimationsContentViewController.h"

@interface MESystemAnimationsContainerViewController () <UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (strong,nonatomic) UIPageViewController *pageViewController;
@end

@implementation MESystemAnimationsContainerViewController

- (UINavigationItem *)navigationItem {
    return [self.pageViewController.viewControllers[0] navigationItem];
}

- (id)init {
    if (!(self = [super init]))
        return nil;
    
    [self setPageViewController:[[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil]];
    [self.pageViewController setDataSource:self];
    [self.pageViewController setDelegate:self];
    [self.pageViewController setViewControllers:@[[[MESystemAnimationsContentViewController alloc] init]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:self.pageViewController];
    [self.view insertSubview:self.pageViewController.view atIndex:0];
    [self.pageViewController didMoveToParentViewController:self];
    
    return self;
}

- (void)viewDidLayoutSubviews {
    [self.pageViewController.view setFrame:self.view.bounds];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    return [[MESystemAnimationsContentViewController alloc] init];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    return [[MESystemAnimationsContentViewController alloc] init];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    [self.navigationController.navigationBar.topItem setTitle:self.navigationItem.title];
}

@end
