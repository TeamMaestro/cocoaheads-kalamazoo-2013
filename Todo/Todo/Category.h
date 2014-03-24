//
//  Category.h
//  Todo
//
//  Created by William Towe on 3/31/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject

@property (strong,nonatomic) NSString *name;

@property (strong,nonatomic) NSSet *todoItems;
@property (strong,nonatomic) NSMutableSet *mutableTodoItems;

@end
