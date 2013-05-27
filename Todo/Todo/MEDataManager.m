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

const struct CoreDataEntityName CoreDataEntityName = {
    .toDoList = @"ToDoList",
    .toDoItem = @"ToDoItem",
    .category = @"Category"
};

@interface MEDataManager ()

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong, readonly) NSManagedObjectContext *persistentManagedObjectContext;

@end

@implementation MEDataManager

- (id)init {
    if (!(self = [super init]))
        return nil;

    // Load up our managed object model. This is the file that's we created with the data model editor
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"TodoModel" withExtension:@"momd"]];
    NSParameterAssert(mom != nil);
    
    // Our persistent store coordinator sits between our persisten stores (the files where the data is written) and our object contexts (scratchpad areas)
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    NSParameterAssert(_persistentStoreCoordinator != nil);
    
    NSURL *storeURL = [self urlForResourceInApplicationSupport:@"ToDo.sqlite"];          // we'll be using SQLite to persist our ToDo Lists
    
    NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption : @(YES),    // automatically migrate store changes if our model has changed.
                               NSInferMappingModelAutomaticallyOption : @(YES)           // try to figure out how to map our old store to our new store, if possible
    };
    NSError *error;
    NSPersistentStore *store = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
    if (!store) {
        NSLog(@"ACK!! could not create persistent store: %@", error);       // we couldn't create a store!! catastrophic failure, blow up!!
        abort();
    }
    
    //
    // Create an NSManagedObjectContext that has it's own processing queue so writes can happen off the main thread, keeping our UI responsive.
    // our UI context will be a child of this context.
    //
    _persistentManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    _persistentManagedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;
    
    
    return self;
}

- (NSManagedObjectContext *)mainQueueManagedObjectContext
//
// our NSManagedObjectContext that works on the main queue, so changes to our data model appear in our UI.
//
{
    static dispatch_once_t onceToken;
    static NSManagedObjectContext *staticContext;
    dispatch_once(&onceToken, ^{
        staticContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        staticContext.parentContext = self.persistentManagedObjectContext;
    });
    return staticContext;
}

- (void)setupCategories
{
    //
    // Just create some categories for our demo. A view controller to handle category creation is left as an exercise
    // for the reader.. :)
    //
    NSArray *categories = [Category allCategoriesInContext:_persistentManagedObjectContext];
    if (categories.count == 0) {
        [@[@"Inbox", @"Delegate", @"Maybe", @"Waiting For", @"Home", @"Work"] enumerateObjectsUsingBlock:^(NSString *categoryName, NSUInteger idx, BOOL *stop) {
            Category *category = [Category createCategoryInContext:self.mainQueueManagedObjectContext];
            category.name = categoryName;
        }];
        NSManagedObjectContext *moc = self.mainQueueManagedObjectContext;
        [moc performBlockAndWait:^{
            [moc save:nil];
            [moc.parentContext performBlockAndWait:^{
                [moc.parentContext save:nil];
            }];
        }];
    }
}

+ (MEDataManager *)sharedManager; {
    static id retval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        retval = [[[self class] alloc] init];
    });
    return retval;
}

#pragma mark - save main managed object context method

- (BOOL)saveMainContextWithError:(NSError **)error
{
    __block BOOL ok;
    NSManagedObjectContext *moc = [[MEDataManager sharedManager] mainQueueManagedObjectContext];
    [moc performBlock:^{
        ok = [moc save:error];
        NSAssert(ok, @"Can't save list on main moc: %@", *error);
        if (ok) {
            [moc.parentContext performBlockAndWait:^{
                [moc.parentContext performBlockAndWait:^{
                    ok = [moc.parentContext save:error];
                    NSAssert(ok, @"Can't save list on persistent moc: %@", *error);
                }];
            }];
        }
    }];
    return ok;
}


#pragma mark - delete managed object methods

- (void)deleteManagedObject:(NSManagedObject *)managedObject
{
    __block NSError *error;
    [[self mainQueueManagedObjectContext] deleteObject:managedObject];
    __weak MEDataManager *weakSelf = self;
    [[self mainQueueManagedObjectContext] performBlock:^{
        [[weakSelf mainQueueManagedObjectContext] save:&error];
        [[[weakSelf mainQueueManagedObjectContext] parentContext] performBlockAndWait:^{
            [[[weakSelf mainQueueManagedObjectContext] parentContext] save:&error];
        }];
    }];
}

#pragma mark - nsfetchrequest methods

- (NSArray *)fetchAllInstancesOf:(NSString *)entityName sortDescriptors:(NSArray *)sortDescriptors filteredBy:(NSPredicate *)filter inContext:(NSManagedObjectContext *)moc
{
    NSFetchRequest *fetchReq = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:moc];
    [fetchReq setEntity:entity];
    [fetchReq setSortDescriptors:sortDescriptors];
    [fetchReq setPredicate:filter];
    NSError *error = nil;
    NSArray *resultSet = [moc executeFetchRequest:fetchReq error:&error];
    return resultSet;
}



#pragma mark - folder methods

- (NSURL *)urlForResourceInApplicationSupport:(NSString *)resourceName
{
    NSURL *appSupport = [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    BOOL ok = [self createDirectoryAtURL:appSupport];
    if (!ok) return nil;
    NSURL *resourceURL = [NSURL fileURLWithPathComponents:@[ [appSupport path], resourceName]];
    return resourceURL;
}

- (BOOL)createDirectoryAtURL:(NSURL *)url
{
    BOOL isDir;
    BOOL doesExist = [[NSFileManager defaultManager] fileExistsAtPath:[url path] isDirectory:&isDir];
    if (doesExist) return YES;
    NSError *error;
    BOOL ok = [[NSFileManager defaultManager] createDirectoryAtURL:url withIntermediateDirectories:YES attributes:nil error:&error];
    NSAssert(ok, @"Unable to create folder: %@", error);
    return ok;
}


@end
