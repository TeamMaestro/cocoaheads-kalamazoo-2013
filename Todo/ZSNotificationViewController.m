//
//  ZSNotificationViewController.m
//  ZephyrSMC
//
//  Created by Will Sawyer on 7/16/14.
//  Copyright (c) 2014 Will Sawyer. All rights reserved.
//

#import "ZSNotificationViewController.h"
#import "ZSUserProfileViewController.h"
#import <Parse/Parse.h>

@interface ZSNotificationViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *notificationTable;
@property (strong, nonatomic) NSArray * notifications;
@end

@implementation ZSNotificationViewController
-(void) viewDidLoad
{
    [self.navigationItem setTitle:@"Notifications"];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
    [table setDelegate:self];
    [table setDataSource:self];
    [self setNotificationTable:table];
    [self.view addSubview:_notificationTable];
    PFQuery *query = [PFQuery queryWithClassName:@"Notification"];
    [query whereKey:@"reciever" equalTo:[PFUser currentUser]];
    
    NSArray *notifications = [query findObjects];
    [self setNotifications:notifications];
}

#pragma UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_notifications count];
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
    
    NSNumber *type = _notifications[indexPath.row][@"type"];
    if ([type isEqualToNumber:[NSNumber numberWithInt:0]])
    {
        PFUser *sender = _notifications[indexPath.row][@"sender"];
        PFObject *object = [sender fetchIfNeeded];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ wants to be your friend!", object[@"firstName"], object[@"lastName"]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *type = _notifications[indexPath.row][@"type"];
    if ([type isEqualToNumber:[NSNumber numberWithInt:0]]) {
        ZSUserProfileViewController *profVC = [[ZSUserProfileViewController alloc] initWithUser:_notifications[indexPath.row][@"sender"]];
        [self.navigationController pushViewController:profVC animated:YES];
    }
}
@end
