//
//  MERootViewController.m
//  Meeting11
//
//  Created by William Towe on 3/17/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "MERootViewController.h"
#import "MEGestureRecognizer.h"
#import <MEFoundation/MEGeometry.h>
#import "MEGuidedTourViewController.h"
#import "MEGuidedTourTransition.h"

@interface MERootViewController () <MEGuidedTourViewControllerDataSource,UIViewControllerTransitioningDelegate>
@property (strong,nonatomic) UIButton *helpButton;
@property (strong,nonatomic) UIView *subview1;
@property (strong,nonatomic) UIView *subview2;
@property (strong,nonatomic) UIView *subview3;

@property (strong,nonatomic) MEGestureRecognizer *gestureRecognizer;
@end

@implementation MERootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setHelpButton:[UIButton buttonWithType:UIButtonTypeSystem]];
    [self.helpButton setTitle:@"Show Help" forState:UIControlStateNormal];
    [self.helpButton addTarget:self action:@selector(_helpButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.helpButton sizeToFit];
    [self.view addSubview:self.helpButton];
    
    [self setSubview1:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 44)]];
    [self.subview1 setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:self.subview1];
    
    [self setSubview2:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)]];
    [self.subview2 setBackgroundColor:[UIColor purpleColor]];
    [self.view addSubview:self.subview2];
    
    [self setSubview3:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)]];
    [self.subview3 setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:self.subview3];
    
    [self setGestureRecognizer:[[MEGestureRecognizer alloc] initWithTarget:self action:@selector(_gestureRecognizerAction:)]];
    [self.gestureRecognizer setMinimumRequiredDistance:100];
    [self.view addGestureRecognizer:self.gestureRecognizer];
}
- (void)viewDidLayoutSubviews {
    [self.helpButton setFrame:ME_CGRectCenter(self.helpButton.frame, self.view.bounds)];
    [self.subview1 setFrame:CGRectMake(20, 40, CGRectGetWidth(self.subview1.frame), CGRectGetHeight(self.subview1.frame))];
    [self.subview2 setFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - CGRectGetWidth(self.subview2.frame) - 20, CGRectGetMaxY(self.helpButton.frame) + 20, CGRectGetWidth(self.subview2.frame), CGRectGetHeight(self.subview2.frame))];
    [self.subview3 setFrame:CGRectMake(20, CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.subview3.frame) - 20, CGRectGetWidth(self.subview3.frame), CGRectGetHeight(self.subview3.frame))];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[MEGuidedTourTransition alloc] initForPresenting:YES];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[MEGuidedTourTransition alloc] initForPresenting:NO];
}

- (NSArray *)viewsForGuidedTourViewController:(MEGuidedTourViewController *)viewController {
    return @[self.subview1,self.subview2,self.subview3,self.helpButton];
}

- (IBAction)_helpButtonAction:(id)sender {
    MEGuidedTourViewController *viewController = [[MEGuidedTourViewController alloc] init];
    
    [viewController setModalPresentationStyle:UIModalPresentationCustom];
    [viewController setTransitioningDelegate:self];
    [viewController setDataSource:self];
    
    [self presentViewController:viewController animated:YES completion:nil];
}
- (IBAction)_gestureRecognizerAction:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Recognized" message:[NSString stringWithFormat:@"You moved at least %@ distance.",@(self.gestureRecognizer.minimumRequiredDistance)] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    
    [alertView show];
}

@end
