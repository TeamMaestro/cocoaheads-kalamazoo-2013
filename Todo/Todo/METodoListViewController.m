//
//  METodoListViewController.m
//  Todo
//
//  Created by William Towe on 3/31/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//

#import "MEEditViewControllerProtocol.h"
#import "METoDoListEditViewController.h"
#import "METodoListViewController.h"
#import "MEDataManager.h"
#import "METableViewCell.h"
#import "METodoItemViewController.h"
#import "ToDoList.h"
#import "ToDoItem.h"

@interface METodoListViewController () <MEEditViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *allLists;

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
    self.allLists = [ToDoList fetchAllInContext:[[MEDataManager sharedManager] mainQueueManagedObjectContext]];
    [self.tableView registerClass:[METableViewCell class] forCellReuseIdentifier:[METableViewCell reuseIdentifier]];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allLists.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    METableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[METableViewCell reuseIdentifier] forIndexPath:indexPath];
    ToDoList *list = [self.allLists objectAtIndex:indexPath.row];
    NSArray *items = [list sortedItems];
    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    [cell.textLabel setText:list.name];
    NSPredicate *whereFinished = [NSPredicate predicateWithFormat:@"isFinished == %d", YES];
    NSArray *completed = [items filteredArrayUsingPredicate:whereFinished];
    [cell.detailTextLabel setText:[NSString stringWithFormat:NSLocalizedString(@"%u item(s), (%u finished)", nil), items.count, completed.count]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ToDoList *list = [self.allLists objectAtIndex:indexPath.row];
        [self.allLists  removeObject:list];
        [[MEDataManager sharedManager] deleteManagedObject:list];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self.allLists exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    [[self allLists] enumerateObjectsUsingBlock:^(ToDoList *list, NSUInteger idx, BOOL *stop) {
        list.order = idx;
    }];
    [self saveContext];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *scratchContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    scratchContext.parentContext = [[MEDataManager sharedManager] mainQueueManagedObjectContext];
    ToDoList *list = [self.allLists objectAtIndex:indexPath.row];
    METoDoListEditViewController *editViewController = [[METoDoListEditViewController alloc] initWithToDoListId:list.objectID managedObjectContext:scratchContext];
    editViewController.delegate = self;
    [self.navigationController pushViewController:editViewController animated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ToDoList *list = [self.allLists objectAtIndex:indexPath.row];
    METodoItemViewController *viewController = [[METodoItemViewController alloc] initWithTodoList:list];        // pass in a scratch context
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)_addItemAction:(id)sender {
    ToDoList *list = [ToDoList newToDoListInContext:[[MEDataManager sharedManager] mainQueueManagedObjectContext]];
    list.order = self.allLists.count;
    list.name = [NSString stringWithFormat:@"To Do List %d", list.order];
    [self.allLists addObject:list];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0] inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self saveContext];
}

#pragma mark - edit view controller delegate method

- (void)editViewController:(UIViewController *)editViewController didSaveObject:(ToDoList *)list
{
    [self saveContext];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - core data methods

- (void)saveContext
{
    NSError *error;
    BOOL ok =  [[MEDataManager sharedManager] saveMainContextWithError:&error];
    if (!ok)
        NSLog(@"Unable to save main moc: %@", error);

}

@end
