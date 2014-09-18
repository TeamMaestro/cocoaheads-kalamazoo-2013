//
//  Fruitstand.m
//  presentation
//
//  Created by Wayne Lovely on 9/14/14.
//  Copyright (c) 2014 WITLOKIM. All rights reserved.
//

#import "Fruitstand.h"
#import "Fruit.h"

@implementation Fruitstand

// Override the initializer so we can allocate some space for our collections
- (id)init
{
    self = [super init];
    if (self)
    {
        self.operators = [[NSMutableArray alloc] init];
        self.fruitBoxes = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)put:(Fruit *)fruit inBox:(NSString *)destinationBox
{
    // make sure space was allocated to hold the array of fruits
    if (!self.fruitBoxes[destinationBox])
    {
        self.fruitBoxes[destinationBox] = [(NSMutableArray *)[NSMutableArray alloc] init];
    }
    NSMutableArray *box = self.fruitBoxes[destinationBox];
    [box addObject:fruit];
    
    /*
     * Some people like composing stuff like this:
     * 
     * [self.fruitBoxes[destinationBox] addObject:fruit];
     *
     * Iterate on that for a minute and see where the brackets leads you [[[[[[[[[[[[[[[]]]]]]]]]]]]]]]
     */
}

- (void)printOperators
{
    NSString *name;
    
    for (name in self.operators)
        NSLog (@"Operator name = %@", name);
}

- (void)printInventory
{
    for (id key in self.fruitBoxes)
    {
        NSLog(@"This box contains %@", key);
        NSMutableArray *box = self.fruitBoxes[key];

        int i = 0;
        for (Fruit *fruit in box)
        {
            i++;
            NSLog(@"Fruit piece (%d).  The diagnosis for this %@ is: %@\n\n", i, fruit.class, fruit.riskEating);
        }
    }
}


@end
