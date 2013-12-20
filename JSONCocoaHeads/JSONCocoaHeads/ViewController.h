//
//  ViewController.h
//  JSONCocoaHeads
//
//  Created by John Pinkster on 12/3/13.
//  Copyright (c) 2013 JohnPinkster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *typeTF;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

- (IBAction)submit:(id)sender;

@end
