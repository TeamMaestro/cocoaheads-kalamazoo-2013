//
//  TodoItem.m
//  Todo
//
//  Created by William Towe on 3/31/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//

#import "TodoItem.h"

@implementation TodoItem

- (id)init {
    if (!(self = [super init]))
        return nil;
    
    [self setName:NSLocalizedString(@"Untitled Item", nil)];
    
    return self;
}

@end
