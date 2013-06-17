//
//  METoDoListEditViewController.m
//  Todo
//
//  Created by Norm Barnard on 5/26/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//

#import "Category.h"
#import "METoDoListEditViewController.h"
#import "ToDoList.h"

static NSString * const kCellId = @"cell";

@interface METoDoListEditViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ToDoList *list;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UITableView *categoryTableView;
@property (nonatomic, strong) NSArray *categories;

@end

@implementation METoDoListEditViewController

- (id)initWithToDoListId:(NSManagedObjectID *)listID managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super init];
    if (!self) return nil;
    
    //
    // we will fetch the list we want to edit by it's NSObjectID using the scratchpad context that was passed in, that way,
    // any changes to the ToDoList NSManagedObject subclass are contained within this context alone.
    //
    _managedObjectContext = managedObjectContext;
    _list = (ToDoList *)[managedObjectContext objectWithID:listID];
    _categories = [Category allCategoriesInContext:_managedObjectContext];
    return self;
}

- (NSString *)nibName
{
    return @"METoDoListEditView";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:self.list.name];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonTapped:)];
    [self.categoryTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellId];
    self.nameField.text = self.list.name;
}

- (IBAction)doneButtonTapped:(UIBarButtonItem *)doneButton
{
    if (self.nameField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Invalid Name", nil) message:NSLocalizedString(@"Try a better name, something a bit longer perhaps", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
        [alert show];
        return;
    }
    //
    // the user wishes to save their edits, so we must save our changes here, and inform our caller that
    // it should save on it's NSManagedObjectContext. our calling view controller contains the reference to
    // our parent NSManagedObjectContext.  We could save on the parent here, but it makes for a cleaner API
    // if our child view controlers only know about the NSManagedObjectContext they received.
    //
    self.list.name = self.nameField.text;
    __weak METoDoListEditViewController *weakSelf = self;
    [self.managedObjectContext performBlockAndWait:^{
        [weakSelf.managedObjectContext save:nil];
        [weakSelf.delegate editViewController:weakSelf didSaveObject:weakSelf.list];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Category *category = [self.categories objectAtIndex:indexPath.row];
    cell.textLabel.text = category.name;
    if (self.list.category == category) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    Category *category = [self.categories objectAtIndex:indexPath.row];
    self.list.category = category;
}

#pragma mark - textfield delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}


@end
