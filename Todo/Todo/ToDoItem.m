//
//  ToDoItem.m
//  Todo
//
//  Created by Norm Barnard on 5/20/13.
//  Copyright (c) 2013 Norm Barnard. All rights reserved.

#import "MEDataManager.h"
#import "ToDoItem.h"
#import "ToDoList.h"

@implementation ToDoItem

@dynamic name;
@dynamic order;
@dynamic priority;
@dynamic notes;
@dynamic isFinished;
@dynamic list;


+ (ToDoItem *)createNewItemInContext:(NSManagedObjectContext *)moc
{
    ToDoItem *item = [NSEntityDescription insertNewObjectForEntityForName:CoreDataEntityName.toDoItem inManagedObjectContext:moc];
    return item;
}

- (NSString *)priorityName
{
    switch (self.priority) {
        case 0:
            return @"Low";
            break;
        case 1:
            return @"Normal";
            break;
        case 2:
            return @"High";
            break;
        default:
            break;
    }
    return @"";
}


@end
