//
//  MEGuidedTourViewController.m
//  Meeting11
//
//  Created by William Towe on 3/19/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "MEGuidedTourViewController.h"
#import <MEReactiveFoundation/MEReactiveFoundation.h>

@interface MEGuidedTourViewController () <UIGestureRecognizerDelegate>
@property (strong,nonatomic) NSArray *helpButtons;
@property (strong,nonatomic) UITapGestureRecognizer *gestureRecognizer;
@end

@implementation MEGuidedTourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self setGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_gestureRecognizerAction:)]];
    [self.gestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:self.gestureRecognizer];
    
    [self setHelpButtons:[[self.dataSource viewsForGuidedTourViewController:self] MER_map:^id(id value) {
        UIButton *retval = [UIButton buttonWithType:UIButtonTypeSystem];
        
        [retval setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        [retval setTintColor:[UIColor whiteColor]];
        [retval setTitle:@"Help" forState:UIControlStateNormal];
        [retval addTarget:self action:@selector(_helpButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:retval];
        
        return retval;
    }]];
}
- (void)viewDidLayoutSubviews {
    [[self.dataSource viewsForGuidedTourViewController:self] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        UIButton *button = self.helpButtons[idx];
        
        [button setFrame:[button convertRect:[view convertRect:view.bounds toView:nil] fromView:nil]];
    }];
}

- (instancetype)initWithDataSource:(id<MEGuidedTourViewControllerDataSource>)dataSource; {
    if (!(self = [super init]))
        return nil;
    
    NSParameterAssert(dataSource);
    
    [self setDataSource:dataSource];
    
    return self;
}

- (IBAction)_gestureRecognizerAction:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)_helpButtonAction:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Help" message:[NSString stringWithFormat:@"Help for view %@",[[self.dataSource viewsForGuidedTourViewController:self] objectAtIndex:[self.helpButtons indexOfObject:sender]]] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    
    [alertView show];
}

@end
