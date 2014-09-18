//
//  Strawberry.m
//  presentation
//
//  Created by Wayne Lovely on 9/14/14.
//  Copyright (c) 2014 WITLOKIM. All rights reserved.
//

#import "Strawberry.h"

@interface Strawberry ()

@property int externalSeedDenisity;

@end


@implementation Strawberry

- (int)externalSeedDensity
{
    return self.externalSeedDenisity;
}

- (void)setExternalSeedDensity:(int)density
{
    self.externalSeedDenisity = density;
}

@end
