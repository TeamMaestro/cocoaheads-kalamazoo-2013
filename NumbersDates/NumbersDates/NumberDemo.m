//
//  NumberDemo.m
//  NumbersDates
//
//  Created by Norm Barnard on 11/20/13.
//  Copyright (c) 2013 Maestro. All rights reserved.
//

#import "NumberDemo.h"

@implementation NumberDemo

- (instancetype)init
{
    self = [super init];
    return self;
}

- (void)run
{
    NSInteger primitiveTen = 10;  // pritmitive integer type
    
    // these two are both objects, one is less typing
    NSNumber *ten = [NSNumber numberWithInteger:primitiveTen];
    NSNumber *literalTen = @10;
    
    NSLog(@"Primitive ten: %ld, object ten: %@ literal object ten: %@", (long)primitiveTen, ten, literalTen);
    
    if ([ten isEqualToNumber:literalTen])
        NSLog(@"both objects have equal value");
        
    if (ten == literalTen)
        NSLog(@"you won't see this printed");
    else
        NSLog(@"%@ != %@ they are different objects, so the are not \"equal\" even though their values are equal \"==\" is pointer equivalence!", ten, literalTen);
    
    if ([ten integerValue] == primitiveTen)
        NSLog(@"%ld == %ld to compare an NSNumber and a primitive type, convert one to the other.", [ten integerValue], primitiveTen);
    
//    if (ten == 10)
//        NSLog(@"This line won't compile!");
    
        
    NSNumber *pi = @(M_PI);       // system macro converted to object using literal syntax
    
    CGFloat radius = 10.0f;
    
    NSLog(@"area of a circle = pi*r*r = %8.4f", [pi doubleValue] * radius * radius);
    
    NSArray *radii = @[@2, @6.5, @7.4, @12, @19, @20.3];    // container classes only hold cocoa objects!
    
    // this is illegal!
    // NSArray *radii = @[2, 6.5, 7.4, 12, 19, 20.3];      // the elements are not objects!
    

    [radii enumerateObjectsUsingBlock:^(NSNumber *r, NSUInteger idx, BOOL *stop) {
        NSLog(@"the area of circle %ld with radius %@ is %8.4f",idx, r, [r doubleValue] * [r doubleValue] * [pi doubleValue]);
    }];
    
    // NSDecimalNumber is a special numeric class for doing base 10 arithmetic.
    // Use it to avoid the messy rounding errors you get with IEEE floating point numbers!
    
    NSDecimalNumber *financialNumber = [NSDecimalNumber decimalNumberWithString:@"123323.56"];
    NSDecimalNumber *mulitplier = [NSDecimalNumber decimalNumberWithMantissa:123 exponent:-1 isNegative:NO];       // this will be 12.3 base 10
    NSLog(@"Total Profit: %@ * %@ =  %@",financialNumber,  mulitplier, [financialNumber decimalNumberByMultiplyingBy:mulitplier]);
}


@end
