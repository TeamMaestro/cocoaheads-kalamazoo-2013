//
//  AFWViewController.m
//  accelSpecifiedInt
//
//  Created by Addison Webb on 1/14/14.
//  Copyright (c) 2014 Addison Apps. All rights reserved.
//

#import "AFWViewController.h"
#import <CoreMotion/CoreMotion.h>

#define kUpdateInterval (1.0f / 60.0f)

@interface AFWViewController ()
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (assign, nonatomic) CMAcceleration acceleration;
@property (strong, nonatomic) NSOperationQueue *queue;
@end

@implementation AFWViewController

- (void)viewDidLoad
{
    self.motionManager = [[CMMotionManager alloc] init];
    self.queue = [[NSOperationQueue alloc] init];
    
    self.motionManager.accelerometerUpdateInterval = kUpdateInterval;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startButton:(id)sender {
    //starts accelerometer updates and calls update method every time the accelerometer refreshes
    [self.motionManager startAccelerometerUpdatesToQueue:self.queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error){
        [(id) self setAcceleration:accelerometerData.acceleration];
        [self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
    }];
}

-(void)update{
    self.xLabel.text = [NSString stringWithFormat:@"%.2f", self.acceleration.x];
    self.yLabel.text = [NSString stringWithFormat:@"%.2f", self.acceleration.y];
    self.zLabel.text = [NSString stringWithFormat:@"%.2f", self.acceleration.z];
}

- (IBAction)stopButton:(id)sender {
    [self.motionManager stopAccelerometerUpdates];
}
@end
