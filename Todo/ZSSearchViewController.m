//
//  ZSSearchViewController.m
//  ZephyrSMC
//
//  Created by Will Sawyer on 7/15/14.
//  Copyright (c) 2014 Will Sawyer. All rights reserved.
//

#import "ZSSearchViewController.h"
#import <Parse/Parse.h>
#import "ZSUserProfileViewController.h"
@interface ZSSearchViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *usersTable;
@property (strong, nonatomic) NSArray * users;
@end

@implementation ZSSearchViewController

-(void) viewDidLoad
{
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
    [table setDelegate:self];
    [table setDataSource:self];
    [self setUsersTable:table];
    [self.view addSubview:_usersTable];
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" notEqualTo:[PFUser currentUser].objectId];
    NSArray* userArray = [query findObjects];
    [self setUsers:userArray];
    
}

#pragma UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_users count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:MyIdentifier];
    }
    
    // Here we use the provided setImageWithURL: method to load the web image
    // Ensure you use a placeholder image otherwise cells will be initialized with no image
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",_users[indexPath.row][@"firstName"],_users[indexPath.row][@"lastName"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSUserProfileViewController *profVC = [[ZSUserProfileViewController alloc] initWithUser:_users[indexPath.row]];
    [self.navigationController pushViewController:profVC animated:YES];
    
}
@end
