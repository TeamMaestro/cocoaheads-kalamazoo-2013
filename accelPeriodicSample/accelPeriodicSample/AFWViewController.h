//
//  AFWViewController.h
//  accelPeriodicSample
//
//  Created by Addison Webb on 1/15/14.
//  Copyright (c) 2014 Addison Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFWViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *xLabel;
@property (weak, nonatomic) IBOutlet UILabel *yLabel;
@property (weak, nonatomic) IBOutlet UILabel *zLabel;

- (IBAction)startButton:(id)sender;
- (IBAction)stopButton:(id)sender;
@end
