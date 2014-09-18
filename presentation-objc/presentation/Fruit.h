//
//  Fruit.h
//  presentation
//
//  Created by Wayne Lovely on 9/13/14.
//  Copyright (c) 2014 WITLOKIM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fruit : NSObject

@property (nonatomic) NSString *color;
@property (nonatomic) int ripeness;

// no getter or setter for ripeness,
// it is influenced by other public methods

- (void)ripen:(int)intensity;
- (BOOL)goodToEat;
- (NSString *)riskEating;

@end

