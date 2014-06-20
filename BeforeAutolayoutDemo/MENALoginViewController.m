//
//  MENALoginViewController.m
//  Meeting14-Autolayout
//
//  Created by Norm Barnard on 6/16/14.
//  Copyright (c) 2014 Maestro. All rights reserved.
//

#import "MENALoginViewController.h"

static const CGFloat kHzMargin = 20.0f;
static const CGFloat kVrMargin = 20.0f;


@interface MENALoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *disclaimerLabel;
@property (weak, nonatomic) IBOutlet UILabel *termLabel;

@end

@implementation MENALoginViewController

- (id)init
{
    self = [super init];
    if (!self) return nil;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Manual Layout";
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    
//    self.usernameField.frame = CGRectMake(kHzMargin, kVrMargin, CGRectGetWidth(self.view.bounds) - 2 * kHzMargin, CGRectGetHeight(self.usernameField.frame));
//    
//    self.passwordField.frame = CGRectMake(kHzMargin, CGRectGetMaxY(self.usernameField.frame) + kVrMargin, CGRectGetWidth(self.view.bounds) - 2 * kHzMargin, CGRectGetHeight(self.passwordField.frame));
//    
//    CGRect textBounds = [self.forgetButton.titleLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.forgetButton.titleLabel.font} context:nil];
//    self.forgetButton.frame = CGRectMake(kHzMargin, CGRectGetMaxY(self.passwordField.frame) + kVrMargin, CGRectGetWidth(textBounds), CGRectGetHeight(textBounds));
//    
//    textBounds = [self.loginButton.titleLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.loginButton.titleLabel.font} context:nil];
//    self.loginButton.frame = CGRectMake(CGRectGetMaxX(self.passwordField.frame) - CGRectGetWidth(textBounds), CGRectGetMaxY(self.passwordField.frame) + kVrMargin, CGRectGetWidth(textBounds), CGRectGetHeight(textBounds));
//    
//    
//    textBounds = [self.disclaimerLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.disclaimerLabel.font} context:nil];
//    self.disclaimerLabel.frame = CGRectMake(kHzMargin, CGRectGetHeight(self.view.bounds) - CGRectGetHeight(textBounds) - kVrMargin, CGRectGetWidth(textBounds), CGRectGetHeight(textBounds));
//
//    textBounds = [self.termLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.termLabel.font} context:nil];
//    
//    self.termLabel.frame = CGRectMake(CGRectGetWidth(self.view.bounds) - CGRectGetWidth(textBounds) - kHzMargin, CGRectGetHeight(self.view.bounds) - CGRectGetHeight(textBounds) - kVrMargin, CGRectGetWidth(textBounds), CGRectGetHeight(textBounds));
    
}

//- (UIRectEdge)edgesForExtendedLayout
//{
//    return UIRectEdgeAll ^ UIRectEdgeTop;
//}



- (IBAction)loginButtonTapped:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)forgetButtonTapped:(id)sender
{
    [self.view endEditing:YES];
}

@end
