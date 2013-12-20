//
//  ViewController.m
//  JSONCocoaHeads
//
//  Created by John Pinkster on 12/3/13.
//  Copyright (c) 2013 JohnPinkster. All rights reserved.
//

#import "ViewController.h"
#import "ServerRequest.h"

@interface ViewController ()

@end


@implementation ViewController

@synthesize submitButton, typeTF;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit:(id)sender {
    NSLog(@"%@", typeTF.text);
    [ServerRequest retrieveJSONWithType:typeTF.text onCompletion:^(NSDictionary *myJSON) {
        dispatch_async(dispatch_get_main_queue(), ^ {
            
            NSString *dataType = myJSON[@"type"];
            
            NSLog(@"**Data Type: %@", dataType);
            
            NSMutableArray *places = myJSON[dataType];
            
            for (NSString *specificLocation in places) {
                NSInteger population = [myJSON[specificLocation] integerValue];
                
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
                [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                
                NSString *populationFormatted = [numberFormatter stringFromNumber:[NSNumber numberWithInteger:population]];
                
                NSLog(@"%@ has %@ people living there!!", specificLocation, populationFormatted);
            
            }
            
            
        });
    }];
    
}
@end
