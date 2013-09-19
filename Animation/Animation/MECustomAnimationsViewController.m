//
//  MECustomViewController.m
//  Animation
//
//  Created by William Towe on 9/8/13.
//  Copyright (c) 2013 Maestro. All rights reserved.
//

#import "MECustomAnimationsViewController.h"
#import "UIColor+MEExtensions.h"

static NSTimeInterval const kAnimationDuration = 0.5;

@interface MECustomAnimationsViewController () <UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>
@property (weak,nonatomic) IBOutlet UIView *animationView;

@property (weak,nonatomic) IBOutlet UIButton *keyframeButton;
@property (weak,nonatomic) IBOutlet UIButton *springButton;
@property (weak,nonatomic) IBOutlet UIButton *presentModalButton;
@property (weak,nonatomic) IBOutlet UIButton *dismissModalButton;
@property (weak,nonatomic) IBOutlet UIButton *dynamicsButton;

@property (strong,nonatomic) UIDynamicAnimator *dynamicAnimator;
@property (strong,nonatomic) NSArray *dynamicViews;
@property (strong,nonatomic) UIGravityBehavior *gravityBehavior;

@end

@implementation MECustomAnimationsViewController

- (UIRectEdge)edgesForExtendedLayout {
    return (UIRectEdgeAll & ~UIRectEdgeBottom);
}

- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationCustom;
}

- (NSString *)title {
    return NSLocalizedString(@"Custom", nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setClipsToBounds:YES];
    [self.view setBackgroundColor:[UIColor ME_colorWithHexadecimalString:[NSString stringWithFormat:@"%p",self]]];
    
    CGRect frame = self.animationView.frame;
    UIColor *backgroundColor = self.animationView.backgroundColor;
    NSMapTable *viewsToFrames = [NSMapTable strongToStrongObjectsMapTable];
    
    for (UIView *subview in self.view.subviews)
        [viewsToFrames setObject:[NSValue valueWithCGRect:subview.frame] forKey:subview];
    
    @weakify(self);

    [self.keyframeButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [input setSelected:!input.isSelected];
            
            [UIView animateKeyframesWithDuration:kAnimationDuration delay:0 options:0 animations:^{
                if (input.isSelected) {
                    [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.33 animations:^{
                        [self.animationView setFrame:CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame))];
                        [self.animationView setBackgroundColor:[UIColor purpleColor]];
                    }];
                    [UIView addKeyframeWithRelativeStartTime:0.33 relativeDuration:0.33 animations:^{
                        [self.animationView setBackgroundColor:[UIColor redColor]];
                    }];
                    [UIView addKeyframeWithRelativeStartTime:0.66 relativeDuration:0.33 animations:^{
                        [self.animationView setTransform:CGAffineTransformMakeScale(1.5, 1.5)];
                    }];
                }
                else {
                    [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.33 animations:^{
                        [self.animationView setTransform:CGAffineTransformIdentity];
                    }];
                    [UIView addKeyframeWithRelativeStartTime:0.33 relativeDuration:0.33 animations:^{
                        [self.animationView setBackgroundColor:[UIColor purpleColor]];
                    }];
                    [UIView addKeyframeWithRelativeStartTime:0.66 relativeDuration:0.33 animations:^{
                        [self.animationView setFrame:frame];
                        [self.animationView setBackgroundColor:backgroundColor];
                    }];
                }
            } completion:^(BOOL finished) {
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }]];
    
    [self.springButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [input setSelected:!input.isSelected];
            
            [UIView animateWithDuration:kAnimationDuration delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:0 animations:^{
                if (input.isSelected) {
                    [self.animationView setTransform:CGAffineTransformScale(CGAffineTransformMakeTranslation(CGRectGetMidX(self.view.bounds), 0), 1.25, 1.25)];
                }
                else {
                    [self.animationView setTransform:CGAffineTransformIdentity];
                }
            } completion:^(BOOL finished) {
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }]];
    
    [self.presentModalButton setRac_command:[[RACCommand alloc] initWithEnabled:[RACSignal combineLatest:@[RACObserve(self, presentedViewController),RACObserve(self, presentingViewController)] reduce:^id(UIViewController *toViewController,UIViewController *fromViewController){
        return @(toViewController != nil || fromViewController == nil);
    }] signalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            MECustomAnimationsViewController *viewController = [[MECustomAnimationsViewController alloc] init];
            
            [viewController setTransitioningDelegate:self];
            
            [self presentViewController:viewController animated:YES completion:^{
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }]];
    
    [self.dismissModalButton setRac_command:[[RACCommand alloc] initWithEnabled:[RACObserve(self, presentingViewController) map:^id(id value) {
        return @(value != nil);
    }] signalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }]];
    
    [self.dynamicsButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [input setSelected:!input.isSelected];
            
            if (input.isSelected) {
                [self setDynamicAnimator:[[UIDynamicAnimator alloc] initWithReferenceView:self.view]];
                
                NSMutableArray *temp = [NSMutableArray arrayWithCapacity:0];
                CGFloat frameX = 1;
                CGFloat frameY = 1;
                CGFloat frameMargin = 25;
                
                for (NSUInteger i=0; i<15; i++) {
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(frameX, frameY, 30, 30)];
                    
                    [view setBackgroundColor:[UIColor ME_colorWithHexadecimalString:[NSString stringWithFormat:@"%p",view]]];
                    
                    [temp addObject:view];
                    
                    frameX = CGRectGetMaxX(view.frame) + frameMargin;
                    
                    [self.view addSubview:view];
                }
                
                [self setDynamicViews:[temp copy]];
                
                [self setGravityBehavior:[[UIGravityBehavior alloc] initWithItems:self.dynamicViews]];
                [self.dynamicAnimator addBehavior:self.gravityBehavior];
                
                UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:[self.dynamicViews arrayByAddingObjectsFromArray:@[self.animationView,self.dynamicsButton,self.keyframeButton,self.presentModalButton,self.dismissModalButton,self.springButton]]];
                
                [collisionBehavior setTranslatesReferenceBoundsIntoBoundary:YES];
                [collisionBehavior setCollisionMode:UICollisionBehaviorModeEverything];
                
                [self.dynamicAnimator addBehavior:collisionBehavior];
                
                [subscriber sendCompleted];
            }
            else {
                [self.dynamicAnimator removeAllBehaviors];
                [self setGravityBehavior:nil];
                [self setDynamicAnimator:nil];
                
                [UIView animateWithDuration:kAnimationDuration delay:0 options:0 animations:^{
                    for (UIView *subview in self.view.subviews) {
                        NSValue *value = [viewsToFrames objectForKey:subview];
                        
                        if (value) {
                            [subview setTransform:CGAffineTransformIdentity];
                            [subview setFrame:[value CGRectValue]];
                        }
                    }
                    for (UIView *subview in self.dynamicViews) {
                        [subview setAlpha:0];
                    }
                } completion:^(BOOL finished) {
                    [self.dynamicViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    [self setDynamicViews:nil];
                    
                    [subscriber sendCompleted];
                }];
            }
            
            return nil;
        }];
    }]];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:nil action:NULL];
    
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [tapGestureRecognizer setNumberOfTouchesRequired:1];
    [tapGestureRecognizer.rac_gestureSignal subscribeNext:^(UIGestureRecognizer *gestureRecognizer) {
        @strongify(self);
        
        [self.dynamicsButton.rac_command execute:self.dynamicsButton];
    }];
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.gravityBehavior setGravityDirection:CGVectorMake(0, self.gravityBehavior.gravityDirection.dy * -1)];
}

#pragma mark UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}
#pragma mark UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return kAnimationDuration;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)context {
    UIViewController *fromViewController = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [context viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *view = [context containerView];
    
    if ([toViewController isKindOfClass:[self class]]) {
        [view addSubview:toViewController.view];
        [toViewController.view setFrame:[view convertRect:self.presentModalButton.frame fromView:self.view]];
        [toViewController.view setAlpha:0];
        
        [UIView animateWithDuration:[self transitionDuration:context] delay:0 options:0 animations:^{
            [toViewController.view setFrame:[view convertRect:CGRectInset(fromViewController.view.bounds, 100, 100) fromView:fromViewController.view]];
            [toViewController.view setAlpha:1];
        } completion:^(BOOL finished) {
            [context completeTransition:YES];
        }];
    }
    else {
        [view addSubview:toViewController.view];
        [toViewController.view setFrame:[context finalFrameForViewController:toViewController]];
        
        [view addSubview:fromViewController.view];
        
        @weakify(self);
        
        [UIView animateWithDuration:[self transitionDuration:context] delay:0 options:0 animations:^{
            @strongify(self);
            
            [fromViewController.view setFrame:[view convertRect:self.dismissModalButton.frame fromView:self.view]];
            [fromViewController.view setAlpha:0];
        } completion:^(BOOL finished) {
            [context completeTransition:YES];
        }];
    }
}


@end
