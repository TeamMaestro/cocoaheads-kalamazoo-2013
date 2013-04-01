//
//  MEDataManager.m
//  Todo
//
//  Created by William Towe on 3/31/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//

#import "MEDataManager.h"
#import "TodoList.h"
#import "TodoItem.h"
#import "Category.h"

@interface MEDataManager ()
@property (readwrite,strong,nonatomic) NSMutableArray *mutableTodoLists;
@end

@implementation MEDataManager

- (id)init {
    if (!(self = [super init]))
        return nil;
    
    [self setMutableTodoLists:[NSMutableArray arrayWithCapacity:0]];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"TodoLists.plist" withExtension:nil];
    NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:NULL];
    NSArray *temp = [NSPropertyListSerialization propertyListWithData:data options:0 format:NULL error:NULL];
    
    for (NSDictionary *listDict in temp) {
        TodoList *list = [[TodoList alloc] init];
        
        [list setName:listDict[@"name"]];
        
        for (NSDictionary *itemDict in listDict[@"items"]) {
            TodoItem *item = [[TodoItem alloc] init];
            
            [item setName:itemDict[@"name"]];
            [item setPriority:[itemDict[@"priority"] integerValue]];
            [item setFinished:[itemDict[@"finished"] boolValue]];
            
            [list.mutableTodoItems addObject:item];
        }
        
        [self.mutableTodoLists addObject:list];
    }
    
    return self;
}

+ (MEDataManager *)sharedManager; {
    static id retval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        retval = [[[self class] alloc] init];
    });
    return retval;
}

- (NSArray *)todoLists {
    return [self.mutableTodoLists copy];
}

@end
