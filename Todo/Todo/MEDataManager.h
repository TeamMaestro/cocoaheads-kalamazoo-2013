//
//  MEDataManager.h
//  Todo
//
//  Created by William Towe on 3/31/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

extern const struct CoreDataEntityName {
	__unsafe_unretained NSString *toDoList;
    __unsafe_unretained NSString *toDoItem;
    __unsafe_unretained NSString *category;
} CoreDataEntityName;

@interface MEDataManager : NSObject

@property (readonly, nonatomic, strong) NSManagedObjectContext *mainQueueManagedObjectContext;
@property (readonly, nonatomic, strong) NSMutableArray *toDoLists;

- (NSArray *)fetchAllInstancesOf:(NSString *)entityName sortDescriptors:(NSArray *)sortDescriptors filteredBy:(NSPredicate *)filter inContext:(NSManagedObjectContext *)moc;
- (void)deleteManagedObject:(NSManagedObject *)managedObject;
- (BOOL)saveMainContextWithError:(NSError **)error;
- (void)setupCategories;
+ (MEDataManager *)sharedManager;

@end
