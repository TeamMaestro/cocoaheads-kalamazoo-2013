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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonTapped:)];
    self.navigationItem.prompt = NSLocalizedString(@"Press \"Done\" to save, \"Back\" to cancel", nil);
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
