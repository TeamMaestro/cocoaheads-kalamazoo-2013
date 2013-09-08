//
//  MEUIViewViewController.m
//  Animation
//
//  Created by William Towe on 9/8/13.
//  Copyright (c) 2013 Maestro. All rights reserved.
//

#import "MEUIViewViewController.h"

#define MEWrappedValue(value, min, max) ((value > max) ? min : value)

typedef NS_ENUM(NSInteger, TransformButtonTag) {
    TransformButtonTagNone,
    TransformButtonTagScale,
    TransformButtonTagRotate,
    TransformButtonTagTranslate
};

static NSTimeInterval const kAnimationDuration = 0.3;

@interface MEUIViewViewController ()
@property (weak,nonatomic) IBOutlet UIView *animationView;

@property (weak,nonatomic) IBOutlet UIButton *frameButton;
@property (weak,nonatomic) IBOutlet UIButton *boundsButton;
@property (weak,nonatomic) IBOutlet UIButton *centerButton;
@property (weak,nonatomic) IBOutlet UIButton *transformButton;
@property (weak,nonatomic) IBOutlet UIButton *alphaButton;
@property (weak,nonatomic) IBOutlet UIButton *backgroundColorButton;
@property (weak,nonatomic) IBOutlet UIButton *resetButton;
@end

@implementation MEUIViewViewController

- (NSString *)title {
    return NSLocalizedString(@"UIView", nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGRect frame = self.animationView.frame;
    CGRect bounds = self.animationView.bounds;
    CGPoint center = self.animationView.center;
    CGAffineTransform transform = self.animationView.transform;
    CGFloat alpha = self.animationView.alpha;
    UIColor *backgroundColor = self.animationView.backgroundColor;
    
    @weakify(self);
    
    [self.frameButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *button) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [button setSelected:!button.isSelected];
            
            [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self.animationView setFrame:(button.isSelected) ? CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMinY(self.animationView.frame), CGRectGetWidth(self.animationView.frame), CGRectGetHeight(self.animationView.frame)) : frame];
                
            } completion:^(BOOL finished) {
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }]];
    
    [self.boundsButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *button) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [button setSelected:!button.isSelected];
            
            [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self.animationView setBounds:(button.isSelected) ? CGRectMake(0, 0, ceilf(CGRectGetWidth(self.animationView.frame) * 2), ceilf(CGRectGetHeight(self.animationView.frame) * 2)) : bounds];
                
            } completion:^(BOOL finished) {
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }]];
    
    [self.centerButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *button) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [button setSelected:!button.isSelected];
            
            [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self.animationView setCenter:(button.isSelected) ? CGPointMake(CGRectGetMidX(self.view.bounds), floorf(CGRectGetMaxY(self.view.bounds) * 0.33)) : center];
                
            } completion:^(BOOL finished) {
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }]];
    
    [self.transformButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *button) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [button setTag:MEWrappedValue(button.tag + 1, TransformButtonTagNone, TransformButtonTagTranslate)];
            
            [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                switch (button.tag) {
                    case TransformButtonTagNone:
                        [self.animationView setTransform:transform];
                        break;
                    case TransformButtonTagScale:
                        [self.animationView setTransform:CGAffineTransformMakeScale(2.5, 1.5)];
                        break;
                    case TransformButtonTagRotate:
                        [self.animationView setTransform:CGAffineTransformMakeRotation(M_PI_4)];
                        break;
                    case TransformButtonTagTranslate:
                        [self.animationView setTransform:CGAffineTransformMakeTranslation(CGRectGetMidX(self.view.bounds), 0)];
                        break;
                    default:
                        break;
                }
                
            } completion:^(BOOL finished) {
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }]];
    
    [self.alphaButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *button) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [button setSelected:!button.isSelected];
            
            [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self.animationView setAlpha:(button.isSelected) ? 0.25 : alpha];
                
            } completion:^(BOOL finished) {
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }]];
    
    [self.backgroundColorButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *button) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [button setSelected:!button.isSelected];
            
            [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self.animationView setBackgroundColor:(button.isSelected) ? [UIColor redColor] : backgroundColor];
                
            } completion:^(BOOL finished) {
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }]];
    
    [self.resetButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [self.animationView setTransform:transform];
            [self.animationView setFrame:frame];
            
            [subscriber sendCompleted];
            
            return nil;
        }];
    }]];
}

@end
