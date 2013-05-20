//
//  Category.m
//  Todo
//
//  Created by William Towe on 3/31/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//

#import "Category.h"

@implementation Category

- (id)init {
    if (!(self = [super init]))
        return nil;
    
    [self setMutableTodoItems:[NSMutableSet setWithCapacity:0]];
    
    return self;
}

@dynamic todoItems;
- (NSSet *)todoItems {
    return [self.mutableTodoItems copy];
}
- (void)setTodoItems:(NSSet *)todoItems {
    [self setMutableTodoItems:[todoItems mutableCopy]];
}

@end
