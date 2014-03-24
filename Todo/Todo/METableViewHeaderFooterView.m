//
//  METableViewHeaderFooterView.m
//  Todo
//
//  Created by William Towe on 4/15/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//

#import "METableViewHeaderFooterView.h"

@implementation METableViewHeaderFooterView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithReuseIdentifier:reuseIdentifier]))
        return nil;
    
    return self;
}

+ (NSString *)reuseIdentifier; {
    return NSStringFromClass(self);
}

@end
