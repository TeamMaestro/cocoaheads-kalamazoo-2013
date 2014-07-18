//
//  ZSLoginViewController.m
//  ZephyrSMC
//
//  Created by Will Sawyer on 5/21/14.
//  Copyright (c) 2014 Will Sawyer. All rights reserved.
//

#import "ZSLoginViewController.h"
#import "ZSMainViewController.h"
#import "ZSRegiesterInformationViewController.h"

@interface ZSLoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmTextField;
@property (weak, nonatomic) IBOutlet UILabel *responseLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *loginEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *loginPasswordTextField;
@end

@implementation ZSLoginViewController
@synthesize managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (void)viewDidAppear:(BOOL)animated
{
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        ZSMainViewController *main = [[ZSMainViewController alloc] initWithUser:currentUser];
        [self presentViewController:main animated:YES completion:NULL];
    }
}
#pragma Login
- (IBAction)loginButtonTapped:(id)sender {
    if ([self allFieldsAreFilledAndValidLogin])
    {
        [PFUser logInWithUsernameInBackground:_loginEmailTextField.text password:_loginPasswordTextField.text
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
                                                ZSMainViewController *main = [[ZSMainViewController alloc] initWithUser:user];
                                                [self presentViewController:main animated:YES completion:NULL];
                                            } else {
                                                _responseLabel.text = @"Invalid Password";
                                            }
                                        }];
        
    }
}
         
-(BOOL)allFieldsAreFilledAndValidLogin
{
    if(!([_loginEmailTextField.text length]>0 && [_loginPasswordTextField.text length]>0))
    {
        _responseLabel.text = @"Please fill all fields";
        return false;
    }
    return true;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
#pragma Register Button
- (IBAction)registerButtonTapped:(id)sender {
    if ([self allFieldsAreFilledAndValidRegister])
    {
        PFQuery *query = [PFUser query];
        [query whereKey:@"email" equalTo:_emailTextField.text];
        NSArray *objects = [query findObjects];
        if([objects count] > 0)
            _responseLabel.text = @"Email already registered";
        else
        {
            PFUser *newUser = [PFUser user];
            newUser.email = _emailTextField.text;
            newUser.password = _passwordTextField.text;
            newUser.username = _emailTextField.text;
            [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [self addToContext:newUser];
                    ZSRegiesterInformationViewController *info = [[ZSRegiesterInformationViewController alloc] initWithUser:newUser];
                    [self presentViewController:info animated:YES completion:NULL];
                } else {
                    NSString *errorString = [error userInfo][@"error"];
                    NSLog(@"%@",errorString);
                }
            }];
            
        }
    }
    
}
-(BOOL)isValidEmail:(NSString *)email
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
    return YES;
}
-(BOOL)allFieldsAreFilledAndValidRegister
{
    if(!([_emailTextField.text length]>0 && [_passwordTextField.text length]>0 && _passwordConfirmTextField>0))
    {
        _responseLabel.text = @"Please fill all fields";
        return false;
    }
    if(![self isValidEmail:_emailTextField.text]){
        _responseLabel.text = @"Invalid Email";
        return false;
    }
    if(!([_passwordConfirmTextField.text isEqualToString:_passwordTextField.text])){
        _responseLabel.text = @"Passwords don't match";
        return false;
    }
    return true;
}
-(void)addToContext:(PFUser *)newUser
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"User" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0)
    {
        NSManagedObjectContext *context = [self managedObjectContext];
        NSManagedObject *user = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"User"
                                 inManagedObjectContext:context];
        [user setValue:newUser[@"email"] forKey:@"email"];
        [user setValue:newUser[@"password"] forKey:@"password"];
        [user setValue:newUser.objectId forKey:@"userID"];
        NSError *error;
        [context save:&error];
    }
}
@end
