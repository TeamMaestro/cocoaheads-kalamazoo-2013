//
//  METodoItemViewController.h
//  Todo
//
//  Created by William Towe on 3/31/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//

#import "METableViewController.h"

@class ToDoList;

@interface METodoItemViewController : METableViewController

- (id)initWithTodoList:(ToDoList *)todoList;

@end
