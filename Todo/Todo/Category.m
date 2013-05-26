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


- (NSMutableArray *)sortedLists
{
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
