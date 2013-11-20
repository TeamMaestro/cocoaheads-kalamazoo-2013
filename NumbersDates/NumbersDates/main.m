//
//  main.m
//  NumbersDates
//
//  Created by Norm Barnard on 11/20/13.
//  Copyright (c) 2013 Maestro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NumberDemo.h"
#import "NSDateDemo.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // insert code here...
        NSLog(@"Number Demo");
        NumberDemo *numberDemo = [[NumberDemo alloc] init];
        [numberDemo run];
        
        NSDateDemo *dateDemo = [[NSDateDemo alloc] init];
        [dateDemo run];
    }
    return 0;
}

