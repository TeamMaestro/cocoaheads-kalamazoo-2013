//
//  main.m
//  presentation
//
//  Created by Wayne Lovely on 9/13/14.
//  Copyright (c) 2014 WITLOKIM. All rights reserved.
//

//  Give a shout out to http://rypress.com/tutorials/objective-c
//  If you're using a reference, throw them some traffic

// run from a terminal for more space
// ~/ios-projects/cocoaheads-20140918/presentation/DerivedData/presentation/Build/Products/Debug/presentation

#import <Foundation/Foundation.h>
#import "Fruitstand.h"
#import "Fruit.h"
#import "Orange.h"
#import "Strawberry.h"
#import "Banana.h"
#import "Grape.h"

// function prototypes
void ripenFruit();
void setUpFruitstand();

// Our friend main()
int main(int argc, const char * argv[])
{
    @autoreleasepool {

        ripenFruit();
        
        NSLog(@"\n\nSet up Fruitstand\n\n");
        
        setUpFruitstand();
    }
    return 0;
}

void ripenFruit()
{
    int i;
    Fruit *fruit = [[Fruit alloc] init];   // <-- Get used to allocating and initializing

    // A property
    fruit.color = @"red";
    
    NSLog(@"The color of the fruit is %@", fruit.color);
    
    while (fruit.goodToEat)
    {
        NSLog(@"Yum! The fruit is good to eat");
        [fruit ripen:1];
    }
    
    for (i=0; i<4; i++)
    {
        fruit.ripeness++;    // We could also call   [fruit ripen:1];
        NSLog(@"%@", fruit.riskEating);
    }
}

void setUpFruitstand()
{
    Orange *orange = [[Orange alloc] init];
    Strawberry *strawberry = [[Strawberry alloc] init];
    Banana *banana = [[Banana alloc] init];
    Grape *grape = [[Grape alloc] init];
    
    Fruitstand *stand = [[Fruitstand alloc] init];
    
    // We need some people to work the stand
    [stand.operators addObject:@"Bob"];
    [stand.operators addObject:@"Carl"];
    [stand.operators addObject:@"George"];
    
    // Put a piece of fruit in each of the boxes
    [stand putFruit:orange inBox:@"oranges"];
    [stand putFruit:strawberry inBox:@"strawberries"];
    [stand putFruit:banana inBox:@"banana"];
    [stand putFruit:grape inBox:@"grapes"];

    NSLog(@"\n\nWho is working the stand ?\n\n");

    // Let's see who is working
    [stand printOperators];
    
    NSLog(@"\n\nCheck the inventory\n\n");
    
    // Let's enumerate what we have in the stand
    [stand printInventory];
    
    NSLog(@"\n\nAdd fruit to stand\n\n");
    
    // Ok, let's stock the stand
    NSSet *boxNames = [NSSet setWithObjects:@"oranges",@"strawberries",@"banana",@"grapes", nil];
    for (NSString *name in boxNames)
    {
        for (int i=0; i<(int)arc4random_uniform(10); i++)
        {
            // statically compiled language so we can't just eval() our way to a fruit
            if ([name isEqualToString:@"oranges"])
            {
                Orange *orange = [[Orange alloc] init];
                [orange setRindSmoothness:@"rough"];
                [orange ripen:(int)arc4random_uniform(10)];
                [stand putFruit:orange inBox:name];
            } else if ([name isEqualToString:@"strawberries"])
            {
                Strawberry *berry = [[Strawberry alloc] init];
                [berry setExternalSeedDensity:(int)arc4random_uniform(5) + 1];
                [berry ripen:(int)arc4random_uniform(10)];
                [stand putFruit:berry inBox:name];
            } else if ([name isEqualToString:@"banana"])
            {
                Banana *banana = [[Banana alloc] init];
                banana.peelThickness = arc4random_uniform(5) + 1;
                [banana ripen:(int)arc4random_uniform(10)];
                [stand putFruit:banana inBox:name];
            } else if ([name isEqualToString:@"grapes"])
            {
                Grape *grape = [[Grape alloc] init];
                grape.seedless = YES;
                [grape ripen:(int)arc4random_uniform(10)];
                [stand putFruit:grape inBox:name];
            }
            
        }
    }
 
    NSLog(@"\n\nRe-check the inventory\n\n");
    
    // Let's enumerate what we have in the stand
    [stand printInventory];
}