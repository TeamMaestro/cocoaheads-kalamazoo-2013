//
//  METodoListViewController.m
//  Todo
//
//  Created by William Towe on 3/31/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//

#import "Category.h"
#import "MEEditViewControllerProtocol.h"
#import "METoDoListEditViewController.h"
#import "METodoListViewController.h"
#import "MEDataManager.h"
#import "METableViewCell.h"
#import "METodoItemViewController.h"
#import "ToDoList.h"
#import "ToDoItem.h"

static NSString *const kUncategorizedKey = @"";

//
// custom protocol that all view controllers that are parents of edit view controllers should
// conform to
//
@interface METodoListViewController () <MEEditViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *categorySectionNames;
@property (nonatomic, strong) NSMutableDictionary *listsByCategory;
@property (nonatomic, strong) NSMutableArray *allLists;

@end

@implementation METodoListViewController

- (id)init
{
    self = [super init];
    if (!self) return nil;
    _listsByCategory = [NSMutableDictionary dictionary];
    return  self;
}

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

    [self.listsByCategory removeAllObjects];
    //
    // retrieve out list of categories. these will be used as the table headings for our to do lists.
    // a category contains a one-to-many relationship on ToDoLists
    // 
    NSArray *categories = [Category allCategoriesInContext:[[MEDataManager sharedManager] mainQueueManagedObjectContext]];
    __weak METodoListViewController *weakSelf = self;
    [categories enumerateObjectsUsingBlock:^(Category *category, NSUInteger idx, BOOL *stop) {
        if (category.todoLists.count > 0)
            [weakSelf.listsByCategory setObject:category.sortedLists forKey:category.name];
    }];
    //
    // a ToDoList can exist without beloning to a Category, so we'll fetch those lists separately, as they will not be faulted on a Category
    //
    NSMutableArray *listSansCategory = [ToDoList listsWithoutCategoryInContext:[[MEDataManager sharedManager] mainQueueManagedObjectContext]];
    NSArray *sortedKeys = [self.listsByCategory.allKeys sortedArrayUsingSelector:@selector(compare:)];
    
    self.categorySectionNames = [sortedKeys mutableCopy];
    [self.listsByCategory setObject:listSansCategory forKey:kUncategorizedKey];
    
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.categorySectionNames.count + 1;      // plus 1 for uncategorized lists
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *lists = [self listsForSectionIndex:section];
    return lists.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    METableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[METableViewCell reuseIdentifier] forIndexPath:indexPath];
    
    ToDoList *list = [self listAtIndexPath:indexPath];
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
        NSMutableArray *categoryLists = [self listsForSectionIndex:indexPath.section];
        ToDoList *list = [self listAtIndexPath:indexPath];
        [categoryLists removeObject:list];
        [[MEDataManager sharedManager] deleteManagedObject:list];
        if (categoryLists.count == 0 && indexPath.section < self.categorySectionNames.count) {
            [self.categorySectionNames removeObjectAtIndex:indexPath.section];
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    return (sourceIndexPath.section != proposedDestinationIndexPath.section) ? sourceIndexPath : proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {

    NSMutableArray *lists = [self listsForSectionIndex:sourceIndexPath.section];
    ToDoList *list = [lists objectAtIndex:sourceIndexPath.row];
    [lists removeObject:list];
    [lists insertObject:list atIndex:destinationIndexPath.row];
    [lists enumerateObjectsUsingBlock:^(ToDoList *list, NSUInteger idx, BOOL *stop) {
        list.order = idx;
    }];
    [self saveContext];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == self.categorySectionNames.count)
        return @"No Category";
    return [self.categorySectionNames objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    // Create a scratch pad managed object context. If the user elects not to save their edits to the ToDoList properties,
    // we simply throw this context away..
    //
    NSManagedObjectContext *scratchContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    scratchContext.parentContext = [[MEDataManager sharedManager] mainQueueManagedObjectContext];
    ToDoList *list = [self listAtIndexPath:indexPath];
    METoDoListEditViewController *editViewController = [[METoDoListEditViewController alloc] initWithToDoListId:list.objectID managedObjectContext:scratchContext];
    editViewController.delegate = self;
    [self.navigationController pushViewController:editViewController animated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ToDoList *list = [self listAtIndexPath:indexPath];
    METodoItemViewController *viewController = [[METodoItemViewController alloc] initWithTodoList:list];        
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)_addItemAction:(id)sender {
    ToDoList *list = [ToDoList newToDoListInContext:[[MEDataManager sharedManager] mainQueueManagedObjectContext]];
    NSMutableArray *uncategorized = [self.listsByCategory objectForKey:kUncategorizedKey];
    list.order = uncategorized.count;
    list.name = [NSString stringWithFormat:@"To Do List %d", list.order];
    [uncategorized addObject:list];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(uncategorized.count-1) inSection:self.categorySectionNames.count]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self saveContext];
}

- (NSMutableArray *)listsForSectionIndex:(NSInteger)section
{
    NSMutableArray *lists;
    if (section == self.categorySectionNames.count) {
        lists = [self.listsByCategory objectForKey:kUncategorizedKey];
    } else {
        NSString *key = [self.categorySectionNames objectAtIndex:section];
        lists = [self.listsByCategory objectForKey:key];
    }
    return lists;
}

- (ToDoList *)listAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *lists = [self listsForSectionIndex:indexPath.section];
    return [lists objectAtIndex:indexPath.row];
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
