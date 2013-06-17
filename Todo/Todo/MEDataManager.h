//
//  MEDataManager.h
//  Todo
//
//  Created by Norm Barnard on 3/31/13.
//  Copyright (c) 2013 Norm Barnard. All rights reserved.
//
//
// File to initialize our core data stack and set up our category demos
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
