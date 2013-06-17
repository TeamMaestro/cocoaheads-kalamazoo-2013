//
//  ToDoList.m
//  Todo
//
//  Created by Norm Barnard on 5/20/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//

#import "Category.h"
#import "MEDataManager.h"
#import "ToDoList.h"
#import "ToDoItem.h"

@implementation ToDoList

@dynamic name;
@dynamic order;
@dynamic items;
@dynamic category;

+ (ToDoList *)newToDoListInContext:(NSManagedObjectContext *)moc
{
    //
    // this is how you create a new object and insert it into your object graph. note that the created object has not
    // been faulted (written to storage) at this point
    //
    ToDoList *list = [NSEntityDescription insertNewObjectForEntityForName:CoreDataEntityName.toDoList inManagedObjectContext:moc];
    return list;
}

+ (NSMutableArray *)fetchAllInContext:(NSManagedObjectContext *)moc
{
    NSSortDescriptor *byOrder = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
    NSArray *results = [[MEDataManager sharedManager] fetchAllInstancesOf:CoreDataEntityName.toDoList sortDescriptors:@[byOrder] filteredBy:nil inContext:moc];
    return [results mutableCopy];
}

+ (NSMutableArray *)listsWithoutCategoryInContext:(NSManagedObjectContext *)moc
{
    //
    // use sort descriptors to order your objects
    // use predicates to limit the items returned based on your specific criteria, in this case, we only
    // want todo lists that aren't associated to a category
    //
    NSSortDescriptor *byOrder = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
    NSPredicate *missingCategory = [NSPredicate predicateWithFormat:@"self.category == nil"];
    NSArray *results = [[MEDataManager sharedManager] fetchAllInstancesOf:CoreDataEntityName.toDoList sortDescriptors:@[byOrder] filteredBy:missingCategory inContext:moc];
    return [results mutableCopy];
}


- (NSMutableArray *)sortedItems
{
    //
    // by default, to-many relationships are NSSet collections, and as a result are unordered. to have a consistent ordering of our
    // todo items, we retrieve all our objects into an array, and return a sorted array.
    //
    NSSortDescriptor *byOrder = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
    NSArray *results =  [[self.items allObjects] sortedArrayUsingDescriptors:@[byOrder]];
    return [results mutableCopy];
}

- (BOOL)addNewToDoItemWithError:(NSError **)error
{
    //
    // create a new todo item in and add it to our list, NOTE: there is an implicit assumption
    // that the NSManagedObjectContext that is associated to our list is on the main queue
    //
    ToDoItem *item = [ToDoItem createNewItemInContext:self.managedObjectContext];
    item.order = self.items.count;
    item.name = [NSString stringWithFormat:@"Item %d", self.items.count];
    [self addItemsObject:item];
    __weak ToDoList *weakSelf = self;
    __block BOOL ok = NO;
    [self.managedObjectContext performBlockAndWait:^{
        ok = [weakSelf.managedObjectContext save:error];
        if (ok) {
            [weakSelf.managedObjectContext.parentContext performBlockAndWait:^{
                ok = [weakSelf.managedObjectContext.parentContext save:error];
            }];
        }
    }];
    return ok;
}

@end
