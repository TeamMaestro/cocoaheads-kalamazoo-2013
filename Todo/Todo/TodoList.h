//
//  ToDoList.h
//  Todo
//
//  Created by Norm Barnard on 5/20/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, ToDoItem;

@interface ToDoList : NSManagedObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) int32_t order;
@property (nonatomic, strong) NSSet *items;
@property (nonatomic, strong) Category *category;

+ (NSMutableArray *)fetchAllInContext:(NSManagedObjectContext *)moc;
+ (NSMutableArray *)listsWithoutCategoryInContext:(NSManagedObjectContext *)moc;
+ (ToDoList *)newToDoListInContext:(NSManagedObjectContext *)moc;
- (NSMutableArray *)sortedItems;
- (BOOL)addNewToDoItemWithError:(NSError **)error;

@end

@interface ToDoList (CoreDataGeneratedAccessors)

- (void)addItemsObject:(ToDoItem *)value;
- (void)removeItemsObject:(ToDoItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
