//
//  MECALayerViewController.m
//  Animation
//
//  Created by William Towe on 9/8/13.
//  Copyright (c) 2013 Maestro. All rights reserved.
//

#import "MECALayerViewController.h"
#import "MEVideoView.h"

#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSInteger, SublayerTransformButtonTag) {
    SublayerTransformButtonTagNone,
    SublayerTransformButtonTagScale,
    SublayerTransformButtonTagRotate,
    SublayerTransformButtonTagTranslate,
    SublayerTransformButtonTagPerspective
};

typedef NS_ENUM(NSInteger, TransformButtonTag) {
    TransformButtonTagNone,
    TransformButtonTagScale,
    TransformButtonTagRotate,
    TransformButtonTagTranslate,
    TransformButtonTagPerspective
};

static CFTimeInterval const kAnimationDuration = 0.3;

@interface MECALayerViewController ()
@property (weak,nonatomic) IBOutlet UIView *animationView;

@property (weak,nonatomic) IBOutlet UIButton *backgroundColorButton;
@property (weak,nonatomic) IBOutlet UIButton *borderColorButton;
@property (weak,nonatomic) IBOutlet UIButton *borderWidthButton;
@property (weak,nonatomic) IBOutlet UIButton *contentsButton;
@property (weak,nonatomic) IBOutlet UIButton *contentsRectButton;
@property (weak,nonatomic) IBOutlet UIButton *cornerRadiusButton;
@property (weak,nonatomic) IBOutlet UIButton *opacityButton;
@property (weak,nonatomic) IBOutlet UIButton *shadowColorButton;
@property (weak,nonatomic) IBOutlet UIButton *shadowOffsetButton;
@property (weak,nonatomic) IBOutlet UIButton *shadowOpacityButton;
@property (weak,nonatomic) IBOutlet UIButton *shadowPathButton;
@property (weak,nonatomic) IBOutlet UIButton *shadowRadiusButton;
@property (weak,nonatomic) IBOutlet UIButton *sublayerTransformButton;
@property (weak,nonatomic) IBOutlet UIButton *transformButton;

@property (weak,nonatomic) IBOutlet UIButton *resetButton;

- (void)_animateValueWithKeyPath:(NSString *)keyPath from:(id)from to:(id)to duration:(CFTimeInterval)duration completion:(void (^)(void))completion;
@end

@implementation MECALayerViewController

- (NSString *)title {
    return NSLocalizedString(@"CALayer", nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *backgroundColor = [UIColor colorWithCGColor:self.animationView.layer.backgroundColor];
    UIColor *borderColor = [UIColor greenColor];
    CGFloat borderWidth = self.animationView.layer.borderWidth;
    CGRect contentsRect = self.animationView.layer.contentsRect;
    CGFloat cornerRadius = self.animationView.layer.cornerRadius;
    CGFloat opacity = self.animationView.layer.opacity;
    UIColor *shadowColor = [UIColor blackColor];
    CGSize shadowOffset = CGSizeZero;
    CGFloat shadowOpacity = 1;
    CGFloat shadowRadius = 10;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.animationView.bounds];
    CATransform3D sublayerTransform = self.animationView.layer.sublayerTransform;
    CATransform3D transform = self.animationView.layer.transform;
    
    [self.animationView.layer setBorderColor:borderColor.CGColor];
    [self.animationView.layer setShadowColor:shadowColor.CGColor];
    [self.animationView.layer setShadowOffset:shadowOffset];
    [self.animationView.layer setShadowOpacity:shadowOpacity];
    [self.animationView.layer setShadowRadius:shadowRadius];
    [self.animationView.layer setShadowPath:shadowPath.CGPath];
    
    UIButton *sublayer1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [sublayer1 setTitle:NSLocalizedString(@"sublayer1", nil) forState:UIControlStateNormal];
    [sublayer1 sizeToFit];
    [sublayer1 setFrame:CGRectMake(20, 20, CGRectGetWidth(sublayer1.frame), CGRectGetHeight(sublayer1.frame))];
    [self.animationView addSubview:sublayer1];
    
    UIButton *sublayer2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [sublayer2 setTitle:NSLocalizedString(@"sublayer2", nil) forState:UIControlStateNormal];
    [sublayer2 sizeToFit];
    [sublayer2 setFrame:CGRectMake(CGRectGetMaxX(self.animationView.bounds) - CGRectGetWidth(sublayer2.frame) - 20, CGRectGetMaxY(self.animationView.bounds) - CGRectGetHeight(sublayer2.frame) - 20, CGRectGetWidth(sublayer2.frame), CGRectGetHeight(sublayer2.frame))];
    [self.animationView addSubview:sublayer2];
    
    MEVideoView *sublayer3 = [[MEVideoView alloc] initWithFrame:CGRectInset(self.animationView.bounds, 50, 50)];
    
    [self.animationView insertSubview:sublayer3 atIndex:0];
    
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
            
            [self _animateValueWithKeyPath:@"contents"
                                      from:self.animationView.layer.contents
                                        to:(__bridge id)((button.isSelected) ? [UIImage imageNamed:@"lolcatsdotcomlikemyself.jpg"].CGImage : [UIImage imageNamed:@"lolcatsdotcompromdate.jpg"].CGImage)
                                  duration:kAnimationDuration
                                completion:^{
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }]];
    
    [self.contentsRectButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *button) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [button setSelected:!button.isSelected];
            
            [self _animateValueWithKeyPath:@"contentsRect"
                                      from:[NSValue valueWithCGRect:self.animationView.layer.contentsRect]
                                        to:(button.isSelected) ? [NSValue valueWithCGRect:CGRectMake(0, 0, 0.5, 0.5)] : [NSValue valueWithCGRect:contentsRect]
                                  duration:kAnimationDuration
                                completion:^{
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }]];
    
    [self.cornerRadiusButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *button) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [button setSelected:!button.isSelected];
            
            [self _animateValueWithKeyPath:@"cornerRadius"
                                      from:@(self.animationView.layer.cornerRadius)
                                        to:(button.isSelected) ? @25 : @(cornerRadius)
                                  duration:kAnimationDuration
                                completion:^{
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }]];
    
    [self.opacityButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *button) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [button setSelected:!button.isSelected];
            
            [self _animateValueWithKeyPath:@"opacity"
                                      from:@(self.animationView.layer.opacity)
                                        to:(button.isSelected) ? @0.25 : @(opacity)
                                  duration:kAnimationDuration
                                completion:^{
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }]];
    
    [self.shadowColorButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *button) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [button setSelected:!button.isSelected];
            
            [self _animateValueWithKeyPath:@"shadowColor"
                                      from:(__bridge id)self.animationView.layer.shadowColor
                                        to:(__bridge id)((button.isSelected) ? [UIColor purpleColor].CGColor : shadowColor.CGColor)
                                  duration:kAnimationDuration
                                completion:^{
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }]];
    
    [self.shadowOffsetButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *button) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [button setSelected:!button.isSelected];
            
            [self _animateValueWithKeyPath:@"shadowOffset"
                                      from:[NSValue valueWithCGSize:self.animationView.layer.shadowOffset]
                                        to:(button.isSelected) ? [NSValue valueWithCGSize:CGSizeMake(25, 25)] : [NSValue valueWithCGSize:shadowOffset]
                                  duration:kAnimationDuration
                                completion:^{
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }]];
    
    [self.shadowOpacityButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *button) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [button setSelected:!button.isSelected];
            
            [self _animateValueWithKeyPath:@"shadowOpacity"
                                      from:@(self.animationView.layer.shadowOpacity)
                                        to:(button.isSelected) ? @0.5 : @(shadowOpacity)
                                  duration:kAnimationDuration
                                completion:^{
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }]];
    
    [self.shadowPathButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *button) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [button setSelected:!button.isSelected];
            
            [self _animateValueWithKeyPath:@"shadowPath"
                                      from:(__bridge id)self.animationView.layer.shadowPath
                                        to:(__bridge id)((button.isSelected) ? [UIBezierPath bezierPathWithOvalInRect:CGRectMake(CGRectGetMinX(self.animationView.bounds), CGRectGetMaxY(self.animationView.bounds), CGRectGetWidth(self.animationView.bounds), 25)].CGPath : shadowPath.CGPath)
                                  duration:kAnimationDuration
                                completion:^{
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }]];
    
    [self.shadowRadiusButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *button) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [button setSelected:!button.isSelected];
            
            [self _animateValueWithKeyPath:@"shadowRadius"
                                      from:@(self.animationView.layer.shadowRadius)
                                        to:(button.isSelected) ? @25 : @(shadowRadius)
                                  duration:kAnimationDuration
                                completion:^{
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }]];
    
    [self.sublayerTransformButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *button) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [button setTag:MEWrappedValue(button.tag + 1, SublayerTransformButtonTagNone, SublayerTransformButtonTagPerspective)];
            
            id toValue;
            
            switch (button.tag) {
                case SublayerTransformButtonTagNone:
                    toValue = [NSValue valueWithCATransform3D:sublayerTransform];
                    break;
                case SublayerTransformButtonTagScale:
                    toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1)];
                    break;
                case SublayerTransformButtonTagRotate:
                    toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_4, 1, 1, 1)];
                    break;
                case SublayerTransformButtonTagTranslate:
                    toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(CGRectGetMidX(self.view.bounds), 0, 0)];
                    break;
                case SublayerTransformButtonTagPerspective: {
                    CATransform3D transform = CATransform3DIdentity;
                    
                    transform.m34 = 0.001;
                    transform = CATransform3DRotate(transform, M_2_SQRTPI, 0, 1, 0);
                    
                    toValue = [NSValue valueWithCATransform3D:transform];
                }
                    break;
                default:
                    toValue = nil;
                    break;
            }
            
            [self _animateValueWithKeyPath:@"sublayerTransform" from:[NSValue valueWithCATransform3D:self.animationView.layer.sublayerTransform] to:toValue duration:kAnimationDuration completion:^{
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }]];
    
    [self.transformButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *button) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [button setTag:MEWrappedValue(button.tag + 1, TransformButtonTagNone, TransformButtonTagPerspective)];
            
            id toValue;
            
            switch (button.tag) {
                case SublayerTransformButtonTagNone:
                    toValue = [NSValue valueWithCATransform3D:transform];
                    break;
                case SublayerTransformButtonTagScale:
                    toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1)];
                    break;
                case SublayerTransformButtonTagRotate:
                    toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_4, 1, 1, 1)];
                    break;
                case SublayerTransformButtonTagTranslate:
                    toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(CGRectGetMidX(self.view.bounds), 0, 0)];
                    break;
                case SublayerTransformButtonTagPerspective: {
                    CATransform3D transform = CATransform3DIdentity;
                    
                    transform.m34 = 0.001;
                    transform = CATransform3DRotate(transform, M_PI_4, 1, 0, 0);
                    
                    toValue = [NSValue valueWithCATransform3D:transform];
                }
                    break;
                default:
                    toValue = nil;
                    break;
            }
            
            [self _animateValueWithKeyPath:@"transform" from:[NSValue valueWithCATransform3D:self.animationView.layer.transform] to:toValue duration:kAnimationDuration completion:^{
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }]];
    
    [self.resetButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [self.animationView.layer setBackgroundColor:backgroundColor.CGColor];
            [self.animationView.layer setContents:nil];
            [self.animationView.layer setBorderColor:borderColor.CGColor];
            [self.animationView.layer setBorderWidth:borderWidth];
            [self.animationView.layer setContentsRect:contentsRect];
            [self.animationView.layer setCornerRadius:cornerRadius];
            [self.animationView.layer setShadowColor:shadowColor.CGColor];
            [self.animationView.layer setShadowOffset:shadowOffset];
            [self.animationView.layer setShadowOpacity:shadowOpacity];
            [self.animationView.layer setShadowRadius:shadowRadius];
            [self.animationView.layer setShadowPath:shadowPath.CGPath];
            [self.animationView.layer setSublayerTransform:sublayerTransform];
            [self.animationView.layer setTransform:transform];
            
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
