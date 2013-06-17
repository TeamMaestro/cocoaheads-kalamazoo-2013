//
//  METodoItemViewController.m
//  Todo
//
//  Created by William Towe on 3/31/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//

#import "MEEditViewControllerProtocol.h"
#import "METodoItemViewController.h"
#import "METoDoItemEditViewController.h"
#import "METableViewCell.h"
#import "MEDataManager.h"
#import "ToDoList.h"
#import "ToDoItem.h"
#import "Category.h"

@interface METodoItemViewController () <MEEditViewControllerDelegate>

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
    
    //
    // get our list of items from our ToDoList in a sorted order. since relationships on NSManagedObject are by default, NSSets,
    // we can't gurantee any return order if we enumerate on the set itsself, we'd likely get a different order each time we
    // load up the app. for a large set of objects, we would probably want to sort once, but since our list of todo items will
    // be small (and since this is a demo) we'll just sort it on demand
    //
    ToDoItem *item = [self.todoList.sortedItems objectAtIndex:indexPath.row];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.textLabel setText:item.name];
    if (item.isFinished)
        cell.detailTextLabel.text = NSLocalizedString(@"Done", nil);
    else
        [cell.detailTextLabel setText:[NSString stringWithFormat:NSLocalizedString(@"Priority: %@", nil),item.priorityName]];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ToDoItem *item = [self.todoList.sortedItems objectAtIndex:indexPath.row];
        //
        // delete the selected item
        //
        [self.todoList removeItemsObject:item];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        //
        // save on our main queue context so the edit sticks
        //
        [[MEDataManager sharedManager] saveMainContextWithError:nil];        
    }
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSMutableArray *sortedItems = self.todoList.sortedItems;
    ToDoItem *item = [sortedItems objectAtIndex:sourceIndexPath.row];
    [sortedItems removeObject:item];
    [sortedItems insertObject:item atIndex:destinationIndexPath.row];
    //
    // the user changed the order of their todo items, we need to update our sort order property and save all the todo items
    // in this list
    //
    [sortedItems enumerateObjectsUsingBlock:^(ToDoItem *item, NSUInteger idx, BOOL *stop) {
        [item setOrder:idx];
    }];
    [[MEDataManager sharedManager] saveMainContextWithError:nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NSLocalizedString(@"Remove", nil);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ToDoItem *item = [self.todoList.sortedItems objectAtIndex:indexPath.row];
    
    // Create a scratch pad managed object context. If the user elects not to save their edits to the ToDoItem properties,
    // we simply throw this context away..
    //
    NSManagedObjectContext *editContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    editContext.parentContext = [[MEDataManager sharedManager] mainQueueManagedObjectContext];
    METoDoItemEditViewController *itemEditController = [[METoDoItemEditViewController alloc] initWithItemId:item.objectID managedObjectContext:editContext];
    itemEditController.delegate = self;
    [self.navigationController pushViewController:itemEditController animated:YES];
}

- (IBAction)_addItemAction:(id)sender {
//
// the user wants to add a new item to this list, call our method to create and add a new item
//
    NSError *error = nil;
    BOOL ok = [self.todoList addNewToDoItemWithError:&error];
    if (!ok) {
        NSLog(@"could not create and add a new todo item to the list: %@", error);
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.todoList.items.count)-1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)editViewController:(UIViewController *)editViewController didSaveObject:(NSManagedObject *)object
{
    NSError *error;
    BOOL ok = [[MEDataManager sharedManager] saveMainContextWithError:&error];
    NSAssert1(ok, @"Unable to save item %@", error);
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}



@end
