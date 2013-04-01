//
//  MEDataManager.h
//  Todo
//
//  Created by William Towe on 3/31/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEDataManager : NSObject

@property (readonly,nonatomic) NSArray *todoLists;
@property (readonly,strong,nonatomic) NSMutableArray *mutableTodoLists;

@property (readonly,nonatomic) NSSet *categories;

+ (MEDataManager *)sharedManager;

@end
