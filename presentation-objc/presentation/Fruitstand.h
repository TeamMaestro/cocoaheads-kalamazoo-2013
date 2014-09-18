//
//  Fruitstand.h
//  presentation
//
//  Created by Wayne Lovely on 9/14/14.
//  Copyright (c) 2014 WITLOKIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fruit.h"

@interface Fruitstand : NSObject

@property NSMutableArray *operators;
@property NSMutableDictionary *fruitBoxes;

- (void)put:(Fruit *)fruit inBox:(NSString *)destinationBox;

- (void)printOperators;
- (void)printInventory;


@end
