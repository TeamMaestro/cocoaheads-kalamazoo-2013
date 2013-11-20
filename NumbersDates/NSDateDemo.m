//
//  NSDateDemo.m
//  NumbersDates
//
//  Created by Norm Barnard on 11/20/13.
//  Copyright (c) 2013 Maestro. All rights reserved.
//

#import <time.h>
#import "NSDateDemo.h"

void dates_the_hard_way()
{
    time_t today = time(NULL);
    today += 5 * 60 * 60 * 24;  // add five days
    struct tm *time_struct = localtime(&today);
    char buf[128];
    strftime(buf, 128, "%Y-%m-%d %H:%M:%s", time_struct);
    NSLog(@"%s", buf);
}


@implementation NSDateDemo



- (void)run
{
    dates_the_hard_way();
    
    // dates that require more typing but will give you a better answer and
    //  have eaiser to read code way..
    // but still make you wish you had the data calculation methods of .NET, Java,
    // Python, Ruby, Lisp, or any language except C....
    
    NSDate *today = [NSDate date];
	NSDateComponents *fiveDays = [NSDateComponents new];
	[fiveDays setDay:5];
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDate *future = [cal dateByAddingComponents:fiveDays toDate:today options:0];
	NSDateFormatter *df = [NSDateFormatter new];
	[df setDateFormat:@"yyyy-MM-dd H:m:s"];
	NSLog(@"%@", [df stringFromDate:future]);
}


@end
