//
//  UIColor+MEExtensions.m
//  Meeting10-UIViewController
//
//  Created by William Towe on 2/19/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "UIColor+MEExtensions.h"

@implementation UIColor (MEExtensions)

// original method can be found at http://www.karelia.com/cocoa_legacy/Foundation_Categories/NSColor__Instantiat.m

+ (UIColor *)ME_colorWithHexadecimalString:(NSString *)hexadecimalString; {
    if (!hexadecimalString.length)
        return nil;
    
    hexadecimalString = [hexadecimalString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
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
