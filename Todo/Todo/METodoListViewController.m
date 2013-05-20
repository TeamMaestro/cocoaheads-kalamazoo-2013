//
//  METodoListViewController.m
//  Todo
//
//  Created by William Towe on 3/31/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//

#import "METodoListViewController.h"
#import "MEDataManager.h"
#import "METableViewCell.h"
#import "METodoItemViewController.h"
#import "TodoList.h"
#import "TodoItem.h"

@interface METodoListViewController ()

@end

@implementation METodoListViewController

- (NSString *)title {
    return NSLocalizedString(@"Todo Lists", nil);
}
- (UINavigationItem *)navigationItem {
    UINavigationItem *retval = [super navigationItem];
    
    [retval setRightBarButtonItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(_addItemAction:)],self.editButtonItem] animated:NO];
    
    return retval;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[METableViewCell class] forCellReuseIdentifier:[METableViewCell reuseIdentifier]];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [MEDataManager sharedManager].todoLists.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    METableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[METableViewCell reuseIdentifier] forIndexPath:indexPath];
    TodoList *list = [[MEDataManager sharedManager].todoLists objectAtIndex:indexPath.row];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell.textLabel setText:list.name];
    [cell.detailTextLabel setText:[NSString stringWithFormat:NSLocalizedString(@"%u item(s), (%u finished)", nil),list.todoItems.count,list.finishedTodoItems.count]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[MEDataManager sharedManager].mutableTodoLists removeObjectAtIndex:indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [[MEDataManager sharedManager].mutableTodoLists exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    
    [[MEDataManager sharedManager].todoLists enumerateObjectsUsingBlock:^(TodoList *list, NSUInteger idx, BOOL *stop) {
        [list setOrder:idx];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    METodoItemViewController *viewController = [[METodoItemViewController alloc] initWithTodoList:[[MEDataManager sharedManager].todoLists objectAtIndex:indexPath.row]];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)_addItemAction:(id)sender {
    [[MEDataManager sharedManager].mutableTodoLists addObject:[[TodoList alloc] init]];
    
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0] inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
