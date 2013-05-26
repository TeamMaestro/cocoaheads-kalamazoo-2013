//
//  METodoItemViewController.m
//  Todo
//
//  Created by William Towe on 3/31/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//

#import "METodoItemViewController.h"
#import "METableViewCell.h"
#import "METodoItemTableHeaderView.h"
#import "METodoItemTableFooterView.h"
#import "MEDataManager.h"
#import "ToDoList.h"
#import "ToDoItem.h"
#import "Category.h"

@interface METodoItemViewController ()

@property (strong,nonatomic) ToDoList *todoList;

@end

@implementation METodoItemViewController

- (id)initWithTodoList:(ToDoList *)todoList; {
    if (!(self = [super init]))
        return nil;
    
    [self setTodoList:todoList];
    
    return self;
}

- (NSString *)title {
    return self.todoList.name;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.todoList.items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    METableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[METableViewCell reuseIdentifier] forIndexPath:indexPath];
    ToDoItem *item = [self.todoList.sortedItems objectAtIndex:indexPath.row];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:(item.isFinished) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone];
    [cell.textLabel setText:item.name];
    [cell.detailTextLabel setText:[NSString stringWithFormat:NSLocalizedString(@"priority %d", nil),item.priority]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ToDoItem *item = [self.todoList.sortedItems objectAtIndex:indexPath.row];
        [self.todoList removeItemsObject:item];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSMutableArray *sortedItems = self.todoList.sortedItems;
    [sortedItems exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    [sortedItems enumerateObjectsUsingBlock:^(ToDoItem *item, NSUInteger idx, BOOL *stop) {
        [item setOrder:idx];
    }];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NSLocalizedString(@"Remove", nil);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ToDoItem *item = [self.todoList.sortedItems objectAtIndex:indexPath.row];
    NSLog(@"tapped item named: %@", item.name);
}

- (IBAction)_addItemAction:(id)sender {
    NSError *error = nil;
    BOOL ok = [self.todoList addNewToDoItemWithError:&error];
    if (!ok)
        NSLog(@"could not create and add a new todo item to the list: %@", error);
}

@end
