//
//  TodoList.m
//  Todo
//
//  Created by William Towe on 3/31/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//

#import "TodoList.h"
#import "TodoItem.h"

@implementation TodoList

- (id)init {
    if (!(self = [super init]))
        return nil;
    
    [self setName:NSLocalizedString(@"Untitled List", nil)];
    [self setMutableTodoItems:[NSMutableArray arrayWithCapacity:0]];
    
    return self;
}

@dynamic todoItems;
- (NSArray *)todoItems {
    return [self.mutableTodoItems copy];
}
- (void)setTodoItems:(NSArray *)todoItems {
    [self setMutableTodoItems:[todoItems mutableCopy]];
}

- (NSArray *)finishedTodoItems {
    NSMutableArray *retval = [NSMutableArray arrayWithCapacity:self.todoItems.count];
    
    for (TodoItem *item in self.todoItems) {
        if (item.isFinished)
            [retval addObject:item];
    }
    
    return retval;
}

@end
