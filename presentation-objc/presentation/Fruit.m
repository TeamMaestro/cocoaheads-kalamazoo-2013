//
//  Fruit.m
//  presentation
//
//  Created by Wayne Lovely on 9/13/14.
//  Copyright (c) 2014 WITLOKIM. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Fruit.h"

@implementation Fruit

- (void)ripen:(int)intensity
{
    self.ripeness += intensity;
}

- (BOOL)goodToEat
{
    if (self.ripeness >= 5)
    {
        return NO;
    } else {
        return YES;
    }
}

-(NSString *)riskEating
{
    NSString *ret;
    
    if (self.ripeness < 5)
    {
        ret = @"Yum !";
    } else {
        switch (self.ripeness)
        {
            case 5:
                ret = @"It will be ok";
                break;
            case 6:
                ret = @"Maybe it's not so bad";
                break;
            case 7:
                ret = @"I really don't want to go to the store, here it goes :O";
                break;
            default:
                ret = @"Guess it is time to toss it :(";
        }
    }

    return ret;
}

@end
