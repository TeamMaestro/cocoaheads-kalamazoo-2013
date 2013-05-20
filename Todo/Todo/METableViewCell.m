//
//  METableViewCell.m
//  Todo
//
//  Created by William Towe on 3/31/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//

#import "METableViewCell.h"

@implementation METableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]))
        return nil;
    
    [self setShowsReorderControl:YES];
    
    return self;
}

+ (NSString *)reuseIdentifier; {
    return NSStringFromClass(self);
}

@end
