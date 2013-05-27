//
//  ToDoItem.h
//  Todo
//
//  Created by Norm Barnard on 5/20/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ToDoList;

@interface ToDoItem : NSManagedObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic) int32_t order;
@property (nonatomic) int16_t priority;
@property (nonatomic, strong) NSString * notes;
@property (nonatomic) BOOL isFinished;
@property (nonatomic, strong) ToDoList *list;

+ (ToDoItem *)createNewItemInContext:(NSManagedObjectContext *)moc;

- (NSString *)priorityName;

@end
