//
//  TodoItem.h
//  Todo
//
//  Created by William Towe on 3/31/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodoItem : NSObject

@property (strong,nonatomic) NSString *name;
@property (assign,nonatomic) int32_t priority;
@property (strong,nonatomic) NSString *notes;
@property (assign,nonatomic,getter = isFinished) BOOL finished;

@end
