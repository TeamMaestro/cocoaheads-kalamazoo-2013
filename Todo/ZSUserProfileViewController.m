//
//  ZSUserProfileViewController.m
//  ZephyrSMC
//
//  Created by Will Sawyer on 5/21/14.
//  Copyright (c) 2014 Will Sawyer. All rights reserved.
//

#import "ZSUserProfileViewController.h"
#import "ZSFriendListViewController.h"
#import "ZSAppDelegate.h"
#import "ZSLoginViewController.h"
#import "ZSSearchViewController.h"

#define myAppDelegate (ZSAppDelegate *)[[UIApplication sharedApplication] delegate]

@interface ZSUserProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UIButton *friendsButton;
@property (weak, nonatomic) IBOutlet UITableView *statisticsTable;
@property (weak, nonatomic) IBOutlet UITableView *networksTable;
@property (strong, nonatomic) PFUser *user;
@end

@implementation ZSUserProfileViewController

- (id)initWithUser:(PFUser *)user
{
    [self setUser:user];
    return self;
}

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
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@ %@", _user[@"firstName"], _user[@"lastName"]]];
    if ([_user.objectId isEqualToString:[PFUser currentUser].objectId])
    {
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButtonTapped:)]];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Log out" style:UIBarButtonItemStyleDone target:self action:@selector(logoutButtonTapped:)]];
    }
    else
    {
        PFRelation *rel = [[PFUser currentUser] relationForKey:@"friends"];
        PFQuery *q = [rel query];
        [q whereKey:@"objectId" equalTo:_user.objectId];
        PFObject *check = [q getFirstObject];
        if (check) { //already friends
            [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:nil] ];
        }
        else
        {
            [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriendButtonTapped:)]];
            PFQuery *query = [PFQuery queryWithClassName:@"Notification"];
            [query whereKey:@"sender" equalTo:[PFUser currentUser]];
            [query whereKey:@"reciever" equalTo:_user];
            [query whereKey:@"type" equalTo:[NSNumber numberWithInt:0]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    if (objects.count > 0) {
                        [self.navigationItem.rightBarButtonItem setEnabled:NO];
                    }
                }
            }];
        }
    }
    
}
- (void) viewWillAppear:(BOOL)animated
{
    PFRelation *rel = [_user relationForKey:@"friends"];
    NSArray *objects = [[rel query] findObjects];
    [_friendsButton setTitle:[NSString stringWithFormat:@"Friends(%d)", objects.count] forState:UIControlStateNormal];
}
- (IBAction)searchButtonTapped:(id)sender {
    ZSSearchViewController *svc = [[ZSSearchViewController alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
}
- (IBAction)addFriendButtonTapped:(id)sender {
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    PFQuery *query = [PFQuery queryWithClassName:@"Notification"];
    [query whereKey:@"sender" equalTo:_user];
    [query whereKey:@"reciever" equalTo:[PFUser currentUser]];
    [query whereKey:@"type" equalTo:[NSNumber numberWithInt:0]];
    //they have requested you already
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                [PFCloud callFunction:@"addFriend" withParameters:@{@"responseUser": _user.objectId}];
            }
            else
                [PFCloud callFunction:@"requestFriend" withParameters:@{@"responseUser": _user.objectId}];
        }
    }];
}
- (IBAction)logoutButtonTapped:(id)sender {
    
    [PFUser logOut];
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)friendsButtonTapped:(id)sender {
    ZSFriendListViewController *flvc = [[ZSFriendListViewController alloc] initWithUser:_user];
    [self.navigationController pushViewController:flvc  animated:YES];
}

@end
