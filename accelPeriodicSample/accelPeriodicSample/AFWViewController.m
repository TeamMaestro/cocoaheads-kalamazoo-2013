//
//  AFWViewController.m
//  accelPeriodicSample
//
//  Created by Addison Webb on 1/15/14.
//  Copyright (c) 2014 Addison Apps. All rights reserved.
//

#import "AFWViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface AFWViewController ()
@property (strong, nonatomic) CMMotionManager *motionManager;

@end

@implementation AFWViewController

- (void)viewDidLoad
{
    self.motionManager = [[CMMotionManager alloc] init];

    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startButton:(id)sender {
    [self.motionManager startAccelerometerUpdates];
    [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(update) userInfo:nil repeats:YES];
}

- (IBAction)stopButton:(id)sender {
    [self.motionManager stopAccelerometerUpdates];
}

-(void) update{
    self.xLabel.text = [NSString stringWithFormat:@"%.2f", self.motionManager.accelerometerData.acceleration.x];
    self.yLabel.text = [NSString stringWithFormat:@"%.2f", self.motionManager.accelerometerData.acceleration.y];
    self.zLabel.text = [NSString stringWithFormat:@"%.2f", self.motionManager.accelerometerData.acceleration.z];
}
@end


