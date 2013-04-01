//
//  TodoList.h
//  Todo
//
//  Created by William Towe on 3/31/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodoList : NSObject

@property (strong,nonatomic) NSString *name;

@property (strong,nonatomic) NSArray *todoItems;
@property (strong,nonatomic) NSMutableArray *mutableTodoItems;

@property (readonly,nonatomic) NSArray *finishedTodoItems;

@end
