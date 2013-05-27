//
//  Category.h
//  Todo
//
//  Created by Norm Barnard on 5/20/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ToDoList;

@interface Category : NSManagedObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSSet *todoLists;

- (NSMutableArray *)sortedLists;
+ (NSMutableArray *)allCategoriesInContext:(NSManagedObjectContext *)moc;
+ (Category *)createCategoryInContext:(NSManagedObjectContext *)moc;

@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addTodoListsObject:(ToDoList *)value;
- (void)removeTodoListsObject:(ToDoList *)value;
- (void)addTodoLists:(NSSet *)values;
- (void)removeTodoLists:(NSSet *)values;

@end
