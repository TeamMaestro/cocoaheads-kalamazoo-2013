//
//  METodoItemViewController.m
//  Todo
//
//  Created by William Towe on 3/31/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//

#import "METodoItemViewController.h"
#import "METableViewCell.h"
#import "METableViewHeaderFooterView.h"
#import "MEDataManager.h"
#import "TodoList.h"
#import "TodoItem.h"
#import "Category.h"

@interface METodoItemViewController ()
@property (strong,nonatomic) TodoList *todoList;
@end

@implementation METodoItemViewController

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
    
    [self.tableView registerClass:[METableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:[METableViewHeaderFooterView reuseIdentifier]];
    [self.tableView registerClass:[METableViewCell class] forCellReuseIdentifier:[METableViewCell reuseIdentifier]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.todoList.todoItems.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    METableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[METableViewCell reuseIdentifier] forIndexPath:indexPath];
    TodoItem *item = [self.todoList.todoItems objectAtIndex:indexPath.row];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:(item.isFinished) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone];
    [cell.textLabel setText:item.name];
    
    NSMutableArray *categories = [NSMutableArray arrayWithCapacity:0];
    
    for (Category *category in [MEDataManager sharedManager].categories) {
        if ([category.todoItems containsObject:item])
            [categories addObject:category];
    }
    
    NSString *categoryString = [[categories valueForKey:@"name"] componentsJoinedByString:@", "];
    
    [cell.detailTextLabel setText:[NSString stringWithFormat:NSLocalizedString(@"priority %d - categories (%@)", nil),item.priority,(categoryString.length == 0) ? NSLocalizedString(@"None", nil) : categoryString]];
    
    return cell;
}

static const CGFloat kHeaderHeight = 44;

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kHeaderHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    METableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[METableViewHeaderFooterView reuseIdentifier]];
    
    [view.textLabel setText:[NSString stringWithFormat:NSLocalizedString(@"%@ - %u item(s), (%u completed)", nil),self.todoList.name,self.todoList.todoItems.count,self.todoList.finishedTodoItems.count]];
    
    return view;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.todoList.mutableTodoItems removeObjectAtIndex:indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self.todoList.mutableTodoItems exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    
    [self.todoList.todoItems enumerateObjectsUsingBlock:^(TodoItem *item, NSUInteger idx, BOOL *stop) {
        [item setOrder:idx];
    }];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NSLocalizedString(@"Remove", nil);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TodoItem *item = [self.todoList.todoItems objectAtIndex:indexPath.row];
    
    [item setFinished:!item.isFinished];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (id)initWithTodoList:(TodoList *)todoList; {
    if (!(self = [super init]))
        return nil;
    
    [self setTodoList:todoList];
    
    return self;
}

- (IBAction)_addItemAction:(id)sender {
    TodoItem *item = [[TodoItem alloc] init];
    
    [self.todoList.mutableTodoItems addObject:item];
    
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0] inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
