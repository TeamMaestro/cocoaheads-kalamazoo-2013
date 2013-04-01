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
@property (strong,nonatomic) NSMutableSet *mutableCategories;
@end

@implementation MEDataManager

- (id)init {
    if (!(self = [super init]))
        return nil;
    
    [self setMutableTodoLists:[NSMutableArray arrayWithCapacity:0]];
    [self setMutableCategories:[NSMutableSet setWithCapacity:0]];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"TodoLists.plist" withExtension:nil];
    NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:NULL];
    NSDictionary *temp = [NSPropertyListSerialization propertyListWithData:data options:0 format:NULL error:NULL];
    
    for (NSDictionary *categoryDict in temp[@"categories"]) {
        Category *category = [[Category alloc] init];
        
        [category setName:categoryDict[@"name"]];
        
        [self.mutableCategories addObject:category];
    }
    
    for (NSDictionary *listDict in temp[@"lists"]) {
        TodoList *list = [[TodoList alloc] init];
        
        [list setName:listDict[@"name"]];
        
        for (NSDictionary *itemDict in listDict[@"items"]) {
            TodoItem *item = [[TodoItem alloc] init];
            
            [item setName:itemDict[@"name"]];
            [item setPriority:[itemDict[@"priority"] integerValue]];
            [item setFinished:[itemDict[@"finished"] boolValue]];
            
            [list.mutableTodoItems addObject:item];
            
            if (item.isFinished) {
                for (Category *category in self.categories)
                    [category.mutableTodoItems addObject:item];
            }
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
- (NSSet *)categories {
    return [self.mutableCategories copy];
}

@end
