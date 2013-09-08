//
//  MECALayerViewController.m
//  Animation
//
//  Created by William Towe on 9/8/13.
//  Copyright (c) 2013 Maestro. All rights reserved.
//

#import "MECALayerViewController.h"

#import <QuartzCore/QuartzCore.h>

static CFTimeInterval const kAnimationDuration = 0.3;

@interface MECALayerViewController ()
@property (weak,nonatomic) IBOutlet UIView *animationView;

@property (weak,nonatomic) IBOutlet UIButton *backgroundColorButton;
@property (weak,nonatomic) IBOutlet UIButton *borderColorButton;
@property (weak,nonatomic) IBOutlet UIButton *borderWidthButton;
@property (weak,nonatomic) IBOutlet UIButton *contentsButton;
@property (weak,nonatomic) IBOutlet UIButton *contentsRectButton;
@property (weak,nonatomic) IBOutlet UIButton *resetButton;

- (void)_animateValueWithKeyPath:(NSString *)keyPath from:(id)from to:(id)to duration:(CFTimeInterval)duration completion:(void (^)(void))completion;
@end

@implementation MECALayerViewController

- (NSString *)title {
    return NSLocalizedString(@"CALayer", nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = self.animationView.frame;
    UIColor *backgroundColor = [UIColor colorWithCGColor:self.animationView.layer.backgroundColor];
    UIColor *borderColor = [UIColor greenColor];
    CGFloat borderWidth = self.animationView.layer.borderWidth;
    CGRect contentsRect = self.animationView.layer.contentsRect;
    
    [self.animationView.layer setBorderColor:borderColor.CGColor];
    
    @weakify(self);
    
    [self.backgroundColorButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *button) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [button setSelected:!button.isSelected];
           
            [self _animateValueWithKeyPath:@"backgroundColor"
                                      from:(__bridge id)self.animationView.layer.backgroundColor
                                        to:(__bridge id)((button.isSelected) ? [UIColor redColor].CGColor : backgroundColor.CGColor)
                                  duration:kAnimationDuration
                                completion:^{
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }]];
    
    [self.borderColorButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *button) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [button setSelected:!button.isSelected];
            
            [self _animateValueWithKeyPath:@"borderColor"
                                      from:(__bridge id)self.animationView.layer.borderColor
                                        to:(__bridge id)((button.isSelected) ? [UIColor purpleColor].CGColor : borderColor.CGColor)
                                  duration:kAnimationDuration
                                completion:^{
                [subscriber sendCompleted];
            }];

            return nil;
        }];
    }]];
    
    [self.borderWidthButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *button) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [button setSelected:!button.isSelected];
            
            [self _animateValueWithKeyPath:@"borderWidth"
                                      from:@(self.animationView.layer.borderWidth)
                                        to:(button.isSelected) ? @10 : @(borderWidth)
                                  duration:kAnimationDuration
                                completion:^{
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }]];
    
    [self.contentsButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *button) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [button setSelected:!button.isSelected];
            
            [self _animateValueWithKeyPath:@"contents" from:self.animationView.layer.contents to:(__bridge id)((button.isSelected) ? [UIImage imageNamed:@"lolcatsdotcomlikemyself.jpg"].CGImage : [UIImage imageNamed:@"lolcatsdotcompromdate.jpg"].CGImage) duration:kAnimationDuration completion:^{
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }]];
    
    [self.contentsRectButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *button) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [button setSelected:!button.isSelected];
            
            [self _animateValueWithKeyPath:@"contentsRect" from:[NSValue valueWithCGRect:self.animationView.layer.contentsRect] to:(button.isSelected) ? [NSValue valueWithCGRect:CGRectMake(0, 0, 0.5, 0.5)] : [NSValue valueWithCGRect:contentsRect] duration:kAnimationDuration completion:^{
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }]];
    
    [self.resetButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [self.animationView setFrame:frame];
            [self.animationView.layer setBackgroundColor:backgroundColor.CGColor];
            [self.animationView.layer setContents:nil];
            [self.animationView.layer setBorderColor:borderColor.CGColor];
            [self.animationView.layer setBorderWidth:borderWidth];
            
            for (UIView *subview in self.view.subviews) {
                if ([subview isKindOfClass:[UIButton class]])
                    [(UIButton *)subview setSelected:NO];
            }
            
            [subscriber sendCompleted];
            
            return nil;
        }];
    }]];
}

- (void)_animateValueWithKeyPath:(NSString *)keyPath from:(id)from to:(id)to duration:(CFTimeInterval)duration completion:(void (^)(void))completion; {
    [CATransaction begin];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    
    [animation setDuration:duration];
    [animation setFromValue:from];
    [animation setToValue:to];
    
    [self.animationView.layer addAnimation:animation forKey:keyPath];
    
    [CATransaction setCompletionBlock:^{
        [self.animationView.layer setValue:animation.toValue forKey:keyPath];
        
        if (completion)
            completion();
    }];
    
    [CATransaction commit];
}

@end
