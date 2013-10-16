//
//  MECalculatorViewController.m
//  CalcDemo2
//
//  Created by Norm Barnard on 10/14/13.
//  Copyright (c) 2013 Maestro. All rights reserved.
//

#import "MECalculatorViewController.h"

typedef enum _CalculatorOperator {
    None,
    Plus,
    Minus,
    Multiply,
    Divide,
    Equals
} CalculatorOperator;


@interface MECalculatorViewController ()

@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *numberButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *operationButtons;
@property (weak, nonatomic) IBOutlet UIButton *decimalButton;
@property (weak, nonatomic) IBOutlet UIButton *allClearButton;

@property (strong, nonatomic) NSMutableString *displayNumberString;
@property (assign, nonatomic) CGFloat accumulator;
@property (assign, nonatomic) CalculatorOperator lastOperator;
@property (assign, nonatomic) BOOL newNumber;

@end

@implementation MECalculatorViewController

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    _displayNumberString = [[NSMutableString alloc] init];
    _accumulator = 0.0f;
    return self;
}


- (NSString *)nibName
{
    return @"MECalculatorView";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)_numberButtonTapped:(UIButton *)sender {
    if (self.newNumber) {
        [self.displayNumberString appendString:[@(sender.tag) stringValue]];
        self.newNumber = NO;
    } else {
        [self.displayNumberString appendString:[@(sender.tag) stringValue]];
    }
    self.displayLabel.text = self.displayNumberString;
}

- (IBAction)_operatorButtonTapped:(UIButton *)sender {

    CGFloat enteredValue = self.displayNumberString.floatValue;
    if (self.lastOperator == None) {
        self.lastOperator = sender.tag;
        self.accumulator = enteredValue;
        [self.displayNumberString setString:@""];
        self.newNumber = YES;
        return;
    }        
    [self _applyOperator:self.lastOperator toAccumulatorWithValue:enteredValue];
    [self.displayNumberString setString:[@(self.accumulator) stringValue]];
    self.displayLabel.text = self.displayNumberString;
    if (sender.tag == Equals)
        self.lastOperator = None;
    else
        self.lastOperator = sender.tag;
    
}

- (IBAction)_decimalButtonTapped:(UIButton *)sender {
    NSRange decimalRange = [self.displayNumberString rangeOfString:@"."];
    if (decimalRange.location == NSNotFound) {
        if (self.displayNumberString.length == 0)
            [self.displayNumberString appendString:@""];
        [self.displayNumberString appendString:@"."];
        self.displayLabel.text = self.displayNumberString;
    }
}

- (IBAction)_allClearButtonTapped:(UIButton *)sender {
    self.accumulator = 0.0f;
    self.lastOperator = None;
    [self.displayNumberString setString:@""];
    self.displayLabel.text = @"0";
}

- (void)_applyOperator:(CalculatorOperator)operator toAccumulatorWithValue:(CGFloat)value
{
    
    switch (operator) {
        case Plus:
            self.accumulator += value;
            break;
        case Minus:
            self.accumulator -= value;
            break;
        case Multiply:
            self.accumulator *= value;
            break;
        case Divide:
            self.accumulator /= value;
            break;
        default:
            self.lastOperator = None;
            break;
    }
}



@end
