//
//  Category.m
//  Todo
//
//  Created by Norm Barnard on 5/20/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//

#import "Category.h"
#import "MEDataManager.h"
#import "ToDoList.h"


@implementation Category

@dynamic name;
@dynamic todoLists;


+ (Category *)createCategoryInContext:(NSManagedObjectContext *)moc
{
    //
    // this is how you create a new object and insert it into your object graph. note that the created object has not
    // been faulted (written to storage) at this point
    //
    Category *category = [NSEntityDescription insertNewObjectForEntityForName:CoreDataEntityName.category inManagedObjectContext:moc];
    return category;
}

- (NSMutableArray *)sortedLists
{
    //
    // by default, to-many relationships are NSSet collections, and as a result are unordered. to have a consistent ordering of our
    // todo items, we retrieve all our objects into an array, and return a sorted array.
    //    
    NSSortDescriptor *byOrder = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
    NSArray *results = [[self.todoLists allObjects] sortedArrayUsingDescriptors:@[byOrder]];
    return [results mutableCopy];
}

+ (NSMutableArray *)allCategoriesInContext:(NSManagedObjectContext *)moc
{
    NSSortDescriptor *byName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray *results = [[MEDataManager sharedManager] fetchAllInstancesOf:CoreDataEntityName.category sortDescriptors:@[byName] filteredBy:nil inContext:moc];
    return [results mutableCopy];
}

@end
