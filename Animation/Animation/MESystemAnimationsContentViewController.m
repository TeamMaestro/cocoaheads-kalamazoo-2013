//
//  MESystemAnimationsContentViewController.m
//  Animation
//
//  Created by William Towe on 9/8/13.
//  Copyright (c) 2013 Maestro. All rights reserved.
//

#import "MESystemAnimationsContentViewController.h"
#import "MESystemAnimationsViewController.h"
#import "MESystemAnimationsContainerViewController.h"
#import "UIColor+MEExtensions.h"

#import <QuickLook/QuickLook.h>

static NSTimeInterval const kAnimationDuration = 0.3;

@interface MERandomBackgroundColorViewController : UIViewController
@property (strong,nonatomic) UILabel *label;
@end

@implementation MERandomBackgroundColorViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor ME_colorWithHexadecimalString:[NSString stringWithFormat:@"%p",self]]];
    
    [self setLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self.label setBackgroundColor:[UIColor clearColor]];
    [self.label setNumberOfLines:0];
    [self.label setTextColor:[UIColor whiteColor]];
    [self.label setText:self.description];
    [self.view addSubview:self.label];
}
- (void)viewDidLayoutSubviews {
    [self.label setFrame:self.view.bounds];
}
@end

@interface MESystemAnimationsContentViewController () <QLPreviewControllerDataSource,QLPreviewControllerDelegate>
@property (weak,nonatomic) IBOutlet UIButton *pushButton;
@property (weak,nonatomic) IBOutlet UISegmentedControl *transitionSegmentedControl;
@property (weak,nonatomic) IBOutlet UISegmentedControl *presentationSegmentedControl;
@property (weak,nonatomic) IBOutlet UIButton *presentButton;
@property (weak,nonatomic) IBOutlet UIButton *previewButton;
@property (weak,nonatomic) IBOutlet UISegmentedControl *transitionFromToSegmentedControl;
@property (weak,nonatomic) IBOutlet UIButton *transitionButton;

@property (strong,nonatomic) UIViewController *transitionViewController;

@property (strong,nonatomic) QLPreviewController *previewController;
@property (readonly,nonatomic) NSArray *previewItems;
@end

@implementation MESystemAnimationsContentViewController

- (UINavigationItem *)navigationItem {
    UINavigationItem *retval = [super navigationItem];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:NULL];
    
    @weakify(self);
    
    [doneItem setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            
            [subscriber sendCompleted];
            
            return nil;
        }];
    }]];
    
    if (self.presentingViewController)
        [retval setRightBarButtonItems:@[doneItem]];
    
    return retval;
}
- (NSString *)title {
    return [NSString stringWithFormat:@"%p",self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor ME_colorWithHexadecimalString:[NSString stringWithFormat:@"%p",self]]];
    
    [self setTransitionViewController:[[MERandomBackgroundColorViewController alloc] init]];
    [self addChildViewController:self.transitionViewController];
    [self.view addSubview:self.transitionViewController.view];
    [self.transitionViewController didMoveToParentViewController:self];
    
    @weakify(self);
    
    [self.pushButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [self.navigationController pushViewController:[[MESystemAnimationsContainerViewController alloc] init] animated:YES];
            
            [subscriber sendCompleted];
            
            return nil;
        }];
    }]];
    
    [[self.transitionSegmentedControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISegmentedControl *segmentedControl) {
        @strongify(self);
        
        if (segmentedControl.selectedSegmentIndex == UIModalTransitionStylePartialCurl)
            [self.presentationSegmentedControl setSelectedSegmentIndex:0];
    }];
    
    [[self.presentationSegmentedControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISegmentedControl *segmentedControl) {
        @strongify(self);
        
        if (self.transitionSegmentedControl.selectedSegmentIndex == UIModalTransitionStylePartialCurl)
            [segmentedControl setSelectedSegmentIndex:UIModalPresentationFullScreen];
    }];
    
    [self.presentButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            UIViewController *viewController = [[MESystemAnimationsViewController alloc] init];
            
            [viewController setModalTransitionStyle:self.transitionSegmentedControl.selectedSegmentIndex];
            [viewController setModalPresentationStyle:self.presentationSegmentedControl.selectedSegmentIndex];
            
            [self presentViewController:viewController animated:YES completion:nil];
            
            [subscriber sendCompleted];
            
            return nil;
        }];
    }]];
    
    [self.previewButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [self setPreviewController:[[QLPreviewController alloc] init]];
            [self.previewController setDataSource:self];
            [self.previewController setDelegate:self];
            
            [self presentViewController:self.previewController animated:YES completion:nil];
            
            [subscriber sendCompleted];
            
            return nil;
        }];
    }]];
    
    [self.transitionButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            UIViewAnimationOptions options = self.transitionFromToSegmentedControl.selectedSegmentIndex << 20;
            UIViewController *toViewController = [[MERandomBackgroundColorViewController alloc] init];
            
            [self addChildViewController:toViewController];
            [toViewController.view setFrame:self.transitionViewController.view.frame];
            
            [self transitionFromViewController:self.transitionViewController toViewController:toViewController duration:kAnimationDuration options:options animations:^{
                [self.transitionViewController.view setAlpha:0];
                [toViewController.view setAlpha:1];
                
            } completion:^(BOOL finished) {
                [self.transitionViewController removeFromParentViewController];
                
                [self setTransitionViewController:toViewController];
                [self.transitionViewController didMoveToParentViewController:self];
                
                [subscriber sendCompleted];
            }];
                        
            return nil;
        }];
    }]];
}
- (void)viewDidLayoutSubviews {
    [self.transitionViewController.view setFrame:CGRectMake(CGRectGetMaxX(self.transitionButton.frame) + 20, CGRectGetMinY(self.transitionButton.frame), 250, 250)];
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return self.previewItems.count;
}
- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return self.previewItems[index];
}

- (CGRect)previewController:(QLPreviewController *)controller frameForPreviewItem:(id<QLPreviewItem>)item inSourceView:(UIView *__autoreleasing *)view {
    if (view)
        *view = self.previewButton;
    
    return self.previewButton.bounds;
}
- (UIImage *)previewController:(QLPreviewController *)controller transitionImageForPreviewItem:(id<QLPreviewItem>)item contentRect:(CGRect *)contentRect {
    NSURL *url = (NSURL *)item;
    
    return [UIImage imageWithContentsOfFile:url.path];
}
- (void)previewControllerDidDismiss:(QLPreviewController *)controller {
    [self setPreviewController:nil];
}

- (NSArray *)previewItems {
    return @[[[NSBundle mainBundle] URLForResource:@"lolcatsdotcomlikemyself.jpg" withExtension:nil],
             [[NSBundle mainBundle] URLForResource:@"ed_1024_512kb.mp4" withExtension:nil],
             [[NSBundle mainBundle] URLForResource:@"lolcatsdotcompromdate.jpg" withExtension:nil]];
}

@end
