//
//  UIColor+MEExtensions.m
//  Animation
//
//  Created by William Towe on 9/19/13.
//  Copyright (c) 2013 Maestro. All rights reserved.
//

#import "UIColor+MEExtensions.h"

@implementation UIColor (MEExtensions)
+ (UIColor *)ME_colorWithHexadecimalString:(NSString *)hexadecimalString; {
    UIColor *retval = nil;
    uint32_t hexadecimalColor;
    NSScanner *scanner = [NSScanner scannerWithString:hexadecimalString];
    
    if (![scanner scanHexInt:&hexadecimalColor])
        return retval;
    
    uint8_t red = (uint8_t)(hexadecimalColor >> 16);
    uint8_t green = (uint8_t)(hexadecimalColor >> 8);
    uint8_t blue = (uint8_t)hexadecimalColor;
    
    retval = [UIColor colorWithRed:(CGFloat)red/0xff green:(CGFloat)green/0xff blue:(CGFloat)blue/0xff alpha:1.0];
    
    return retval;
}
@end
