//
//  METoDoItemEditViewController.m
//  Todo
//
//  Created by Norm Barnard on 5/27/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//
#import <CoreData/CoreData.h>
#import "MEDataManager.h"
#import "METoDoItemEditViewController.h"
#import "TodoItem.h"
#import "TodoList.h"

@interface METoDoItemEditViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) ToDoItem *item;

@property (nonatomic, weak) IBOutlet UISwitch *completionSwitch;
@property (nonatomic, weak) IBOutlet UISegmentedControl *prioritySegment;
@property (nonatomic, weak) IBOutlet UITextField *nameField;

@end

@implementation METoDoItemEditViewController

- (id)initWithItemId:(NSManagedObjectID *)itemId managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super init];
    if (!self) return nil;
    _managedObjectContext = managedObjectContext;
    _item = (ToDoItem *)[managedObjectContext objectWithID:itemId];
    return self;
}

- (NSString *)nibName
{
    return @"METoDoItemEditView";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nameField.text = self.item.name;
    if (self.item.priority > -1 && self.item.priority < self.prioritySegment.numberOfSegments)
        self.prioritySegment.selectedSegmentIndex = self.item.priority;
    self.completionSwitch.on = self.item.isFinished;
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(_doneButtonTapped:)];
    self.navigationItem.rightBarButtonItem = backBtn;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)_switchValueDidChange:(UISwitch *)switchControl
{
    self.item.isFinished = switchControl.on;
}

- (IBAction)_segmentSelectedSegmentChanged:(UISegmentedControl *)segmentControl
{
    self.item.priority = segmentControl.selectedSegmentIndex;
}

- (IBAction)_doneButtonTapped:(UIBarButtonItem *)doneButton
{
    if (self.item.name.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Invalid Name", nil) message:NSLocalizedString(@"Try a better name, something a bit longer perhaps", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
        [alert show];
        return;        
    }
    
    self.item.name = self.nameField.text;
    __weak METoDoItemEditViewController *weakSelf = self;
    [self.managedObjectContext performBlockAndWait:^{
        [weakSelf.managedObjectContext save:nil];
        [weakSelf.delegate editViewController:weakSelf didSaveObject:weakSelf.item];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.item.name = textField.text;
    return NO;
}


@end
