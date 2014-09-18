//
//  Orange.m
//  presentation
//
//  Created by Wayne Lovely on 9/14/14.
//  Copyright (c) 2014 WITLOKIM. All rights reserved.
//

#import "Orange.h"

@interface Orange ()

@property (nonatomic) NSString *rindSmoothness;

@end


@implementation Orange {
}

- (NSString *)getRindSmoothness
{
    return self.rindSmoothness;
}

- (void)setRindSmoothness:(NSString *)smoothness
{
    [self.rindSmoothness initWithString:smoothness];
}

@end
