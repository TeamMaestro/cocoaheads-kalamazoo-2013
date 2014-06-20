//
//  MEALLoginViewController.m
//  Meeting14-Autolayout
//
//  Created by Norm Barnard on 6/16/14.
//  Copyright (c) 2014 Maestro. All rights reserved.
//

#import "MEALLoginViewController.h"

@interface MEALLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;
@property (weak, nonatomic) IBOutlet UILabel *disclaimerLabel;
@property (weak, nonatomic) IBOutlet UIView *termsLabel;

@end

@implementation MEALLoginViewController

- (id)init
{
    self = [super init];
    if (!self) return nil;
    return self;
}

- (NSString *)nibName
{
    return @"MEALLoginView";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Auto Layout";
}

//- (UIRectEdge)edgesForExtendedLayout
//{
//    return UIRectEdgeAll ^ UIRectEdgeTop;
//}


- (IBAction)loginButtonTapped:(UIButton *)sender
{
    [self.view endEditing:YES];
}

- (IBAction)forgetButtonTapped:(UIButton *)sender
{
    [self.view endEditing:YES];
}

@end
