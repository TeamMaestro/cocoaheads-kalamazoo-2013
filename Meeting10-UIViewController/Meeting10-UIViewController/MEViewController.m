//
//  MEViewController.m
//  Meeting10-UIViewController
//
//  Created by William Towe on 2/19/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "MEViewController.h"
#import "UIColor+MEExtensions.h"
#import "MENavigationController.h"
#import "MEView.h"

/**
 Standard Apple recommended padding.
 
 Distance from the edge of a containing view to a subview.
 */
static CGFloat const kSubviewPadding = 20;
/**
 Standard Apple recommended margin.
 
 Distance from the edge of one subview to another subview.
 */
static CGFloat const kSubviewMargin = 8;
/**
 Standard Apple recommended minimum width/height for subviews that are tappable.
 */
static CGFloat const kSubviewWidthHeight = 44;

@interface MEViewController () <UIPopoverControllerDelegate,UIAlertViewDelegate>

@property (strong,nonatomic) UIButton *popoverButton;
@property (strong,nonatomic) UIButton *pushButton;

@property (strong,nonatomic) MEView *customView;

@property (strong,nonatomic) UIPopoverController *contentPopoverController;

@end

@implementation MEViewController
#pragma mark *** Subclass Overrides ***
#pragma mark iOS 7 Layout
/**
 This affects how the receiver's `frame` is set with respect to its containing `UINavigationController` or `UITabBarController`.
 
 The default is `UIRectEdgeAll`.
 
 The possible return values can be bitwise OR'd together to specify multiple edges (e.g. `UIRectEdgeTop | UIRectEdgeBottom`).
 
 - `UIRectEdgeNone`, a containing `UINavigationBar` or `UITabBar` will *not* overlay the receiver (no blur effect)
 - `UIRectEdgeTop`, a containing `UINavigationBar` *will* overlay the receiver (blur effect)
 - `UIRectEdgeLeft`, currently ignored
 - `UIRectEdgeBottom`, a containing `UITabBar` *will* overlay the receiver (blur effect)
 - `UIRectEdgeRight`, currently ignore
 */
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeAll;
}
/**
 If you do not specify `UIRectEdgeTop` as part of `edgesForExtendedLayout` this effects whether the containing `UINavigationController` will adjust the receiver's frame so the `UINavigationBar` overlays it.
 
 The default is NO.
 */
- (BOOL)extendedLayoutIncludesOpaqueBars {
    return NO;
}
/**
 This affects whether the receiver will automatically adjust the `contentInset` of the root level `UIScrollView` instance.
 
 This is important when either `UIRectEdgeTop` or `UIRectEdgeBottom` are returned from `edgesForExtendedLayout` above as it ensures the `UIScrollView` content won't be covered up initially, but still allows for the live blurring effect while content is being scrolled.
 
 The default is YES.
 
 *NOTE:* `UITableViewController` makes use of this property to adjust the `contentInset` of its managed `UITableView` instance.
 */
- (BOOL)automaticallyAdjustsScrollViewInsets {
    return YES;
}
/**
 Tells other parts of the system (including other instances of `UIViewController` within your application) the preferred size of the receiver's `view`.
 
 *NOTE:* `UIPopoverController` references this value to determine how big the popover should be to contain the receiver.
 */
- (CGSize)preferredContentSize {
    return CGSizeMake(320, 320);
}
#pragma mark Status Bar
/**
 Affects the color of the status bar.
 
 The default is, unsurprisingly, `UIStatusBarStyleDefault`.
 
 - `UIStatusBarStyleDefault`, black text
 - `UIStatusBarStyleLightContent`, white text
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
/**
 Affects whether the status bar is hidden.
 
 The default is NO.
 */
- (BOOL)prefersStatusBarHidden {
    return NO;
}
/**
 Affects the animation to use when animating a change to the status bar.
 
 The default is `UIStatusBarAnimationFade`.
 
 *NOTE:* The receiver must call `setNeedsStatusBarAppearanceUpdate` within an animation block in order to trigger an animated update to the status bar. Otherwise an animated update is only triggered during system transitions (e.g. present/dismiss).
 
 - `UIStatusBarAnimationNone`, no animation
 - `UIStatusBarAnimationFade`, cross fade animation
 - `UIStatusBarAnimationSlide`, slide up animation
 */
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

#pragma mark Presentation
/**
 Affects the transition that is used when doing a system present/dismiss animation.
 
 The default is `UIModalTransitionStyleCoverVertical`.
 
 - `UIModalTransitionStyleCoverVertical`, the slide up from the bottom transition
 - `UIModalTransitionStyleFlipHorizontal`, flip the receiver's `view` around its y axis to reveal the next view
 - `UIModalTransitionStyleCrossDissolve`, simple cross fade animation to the next view
 - `UIModalTransitionStylePartialCurl`, page curl from bottom right corner transition
 */
- (UIModalTransitionStyle)modalTransitionStyle {
    return UIModalTransitionStyleCoverVertical;
}
/**
 Affects how the receiver is presented modally by the system.
 
 The default is `UIModalPresentationFullScreen`.
 
 - `UIModalPresentationFullScreen`, cover the entire screen (iPhone/iPad)
 - `UIModalPresentationPageSheet`, left/right edges are inset a bit (iPad only)
 - `UIModalPresentationFormSheet`, inset top/left/bottom/right edges considerably and center the view (iPad only)
 - `UIModalPresentationCustom`, fancy custom presentation animation (iPhone/iPad, iOS 7 only)
 
 *NOTE:* `UIModalPresentationCustom` has some other requirements, see the `transitioningDelegate` property and the `UIViewControllerTransitioningDelegate` and `UIViewControllerAnimatedTransitioning` protocols.
 */
- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationFullScreen;
}
/**
 Affects whether the receiver can be dismissed by tapping outside of the popover it is being presented in.
 
 The default is NO.
 
 *NOTE:* If this returns YES, there must be another way to dismiss the popover (e.g. a cancel `UIBarButtonItem`).
 */
- (BOOL)isModalInPopover {
    return NO;
}
#pragma mark Navigation Item
/**
 The title displayed in the `UINavigationBar` when the receiver is the `topViewController` of a `UINavigationController`.
 
 Also used for the title of the `UITabBarItem` in a `UITabBar` when the receiver is within a `UITabBarController`.
 */
- (NSString *)title {
    return [NSString stringWithFormat:@"%p",self];
}
/**
 This affects what is displayed when the receiver is the `topViewController` of a `UINavigationController`. It encapsulates the title of the receiver and any `UIBarButtonItem` instances that should be displayed.
 
 The default value will use the value returned from `title` for the receiver's `title` property.
 
 *NOTE:* You *must* call `[super navigationItem]` and manipulate its value and return the result.
 */
- (UINavigationItem *)navigationItem {
    UINavigationItem *retval = [super navigationItem];
    /**
     See the `UIBarButtonItem` documentation for the constants passed to this method represent.
     
     In this case get a button that says "Done" and a button with a plus icon.
     */
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_doneItemAction:)];
    UIBarButtonItem *presentItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(_presentItemAction:)];
    
    /**
     Are we being presented modally? If so, then show the done item allowing the user to dismiss us.
     */
    if (self.presentingViewController)
        [retval setRightBarButtonItems:@[presentItem,doneItem]];
    else
        [retval setRightBarButtonItems:@[presentItem]];
    
    return retval;
}
#pragma mark Initialization
/**
 `init`
    |
 `viewWillMoveToParentViewController:`
    |
 `viewDidLoad`
    |
 `viewWillAppear:` (always paired with `viewDidAppear:`)
    |
 'viewWillLayoutSubviews` (always paired wtih `viewDidLayoutSubviews`)
    |
 `viewDidLayoutSubviews`
    |
 `viewDidAppear:`
    |
 `didMoveToParentViewController:`
 */
- (id)init {
    if (!(self = [super init]))
        return nil;
    
    /**
     Do any initialization that should be done before the receiver's view is loaded.
     
     This method is called only once.
     
     *NOTE:* You *must* do the `self = [super init]` assignment.
     */
    
    return self;
}
#pragma mark View
/**
 Called the first time the receiver's `view` property is requested.
 
 Create the receiver's subviews and assign them to the requisite properties, along with adding them to the receiver's `view` as subviews.
 
 *NOTE:* You *must* call `[super viewDidLoad]`.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     Set the `backgroundColor` of the receiver's `view` to something random.
     */
    [self.view setBackgroundColor:[UIColor ME_colorWithHexadecimalString:[NSString stringWithFormat:@"%p",self]]];
    
    [self setPopoverButton:[UIButton buttonWithType:UIButtonTypeSystem]];
    /**
     Always use `NSLocalizedString` to wrap strings that the user will see.
     
     The first argument is the string to show, the second is a comment indicating the context for the displayed string.
     */
    [self.popoverButton setTitle:NSLocalizedString(@"Show Popover", @"show popover button title") forState:UIControlStateNormal];
    [self.popoverButton addTarget:self action:@selector(_popoverButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.popoverButton sizeToFit];
    [self.view addSubview:self.popoverButton];
    
    [self setPushButton:[UIButton buttonWithType:UIButtonTypeSystem]];
    [self.pushButton setTitle:NSLocalizedString(@"Push View Controller", @"push view controller button title") forState:UIControlStateNormal];
    [self.pushButton addTarget:self action:@selector(_pushButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.pushButton sizeToFit];
    [self.view addSubview:self.pushButton];
    
    [self setCustomView:[[MEView alloc] initWithFrame:CGRectZero]];
    [self.customView sizeToFit];
    [self.view addSubview:self.customView];
    
    MELog();
}
#pragma mark Memory
/**
 Called when the system determines your application is using too much memory, giving it a chance to clean up resources.
 
 For example, if you are maintaining a cache of Twitter avatar images, you could dispose of them here to free up memory.
 
 *NOTE:* You *must* call `[super didReceiveMemoryWarning]`.
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    MELog();
}
#pragma mark Layout
/**
 Called right before the receiver's `view` has its `layoutSubviews` method called.
 
 *NOTE:* The size of the receiver's `view` has not been set when this method is called.
 */
- (void)viewWillLayoutSubviews {
    MELog();
}
/**
 Called right after the receiver's `view` has its `layoutSubviews` method called.
 
 You should position the subview's of your `view` in this method using the `setFrame:` method on `UIView`.
 
 *NOTE:* If you are using autolayout, any layout changes made in this method will be undone by the autolayout engine.
 */
- (void)viewDidLayoutSubviews {
    [self.popoverButton setFrame:CGRectMake(kSubviewPadding, 100, CGRectGetWidth(self.popoverButton.frame), kSubviewWidthHeight)];
    [self.pushButton setFrame:CGRectMake(kSubviewPadding, CGRectGetMaxY(self.popoverButton.frame) + kSubviewMargin, CGRectGetWidth(self.pushButton.frame), kSubviewWidthHeight)];
    
    [self.customView setFrame:CGRectMake(kSubviewPadding, CGRectGetMaxY(self.pushButton.frame) + kSubviewMargin, CGRectGetWidth(self.customView.frame), CGRectGetHeight(self.customView.frame))];
    
    MELog();
}
#pragma mark Transition
/**
 Called right before the receiver becomes visible and begins an (optional) transition animation.
 
 *NOTE:* You *must* call `[super viewWillAppear:animated]`.
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    MELog();
}
/**
 Called right after the receiver becomes visible and has finished an (optional) transition animation.
 
 *NOTE:* You *must* call `[super viewDidAppear:animated]`.
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    MELog();
}
/**
 Called right before the receiver is hidden and begins an (optional) transition animation.
 
 *NOTE:* You *must* call `[super viewWillDisappear:animated]`.
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    MELog();
}
/**
 Called right after the receiver is hidden and has finished an (optional) transition animation.
 
 *NOTE:* You *must* call `[super viewDidDisappear:animated]`.
 */
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    MELog();
}
#pragma mark Rotation
/**
 Called right before the receiver rotates to a new orientation.
 
 *NOTE:* You *must* call `[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration]`.
 */
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    MELog();
}
/**
 Called within an animation block while the receiver is rotating. Any changes that can be animated will be along with the rotation.
 */
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    MELog();
}
/**
 Called right after the receiver has rotated to a new orientation.
 
 *NOTE:* You *must* call `[super didRotateFromInterfaceOrientation:fromInterfaceOrientation]`.
 */
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    MELog();
}
#pragma mark Child/Parent View Controllers
/**
 Called right before the receiver moves to a container view controller (e.g. `UINavigationController`, `UITabBarController` or a `UIViewController` container subclass).
 
 *NOTE:* You must call `[super willMoveToParentViewController:parent]`.
 */
- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    
    MELog();
}
/**
 Called right after the receiver moves to a container view controller and all (optional) transition have finished.
 
 *NOTE:* You must call `[super didMoveToParentViewController:parent]`.
 */
- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
    
    MELog();
}
#pragma mark UIPopoverControllerDelegate
/**
 Called when the user taps outside the popover.
 
 If you return YES, the popover dismisses normally, while NO prevents it from dismissing.
 
 *NOTE:* This delegate method can be used to determine whether the popover should dismiss on a case by case basis. Contrast this with returning YES from `isModalInPopover`, which will always disable the dismissal of the popover.
 */
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Dismiss Popover", @"dismiss popover alert title") message:NSLocalizedString(@"Are you sure you want to dismiss the popover?", @"dismiss popover alert message") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"dismiss popover alert cancel button title") otherButtonTitles:NSLocalizedString(@"Dismiss", @"dismiss popover alert dismiss button title"), nil];
    
    [alertView show];
    
    return NO;
}
/**
 Called once the popover is dimissed.
 
 Use this method to clear out any state related to the popover. Namely, the instance of `UIPopoverController` that was being displayed.
 
 *NOTE:* This delegate method is not called when the popover is programmatically dismissed (e.g. `[[self.contentPopoverController dismissPopoverAnimated:YES]`).
 */
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [self setContentPopoverController:nil];
}
#pragma mark UIAlertViewDelegate
/**
 Called once the user taps on a button in the alert view. This is the most common way to handle acting on the user's choice for a particular `UIAlertView` instance.
 */
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        /**
         Dismiss the popover programmatically.
         */
        [self.contentPopoverController dismissPopoverAnimated:YES];
        /**
         Clean up the `UIPopoverController` instance that was being displayed. `popoverControllerDidDismissPopover:` will not be called since we dismissed the popover using `[self.contentPopoverController dismissPopoverAnimated:YES]` above, so we must do this here.
         */
        [self setContentPopoverController:nil];
    }
}
#pragma mark *** Private Methods ***
#pragma mark Actions
/**
 Actions corresponding to `UIBarButtonItem` instances in the receiver's `UINavigationItem` as well as `UIButton` instances the receiver's `view` contains.
 */
- (IBAction)_presentItemAction:(id)sender {
    /**
     Present a new view controller modally. This is the standard way to present a view controller modally.
     */
    [self presentViewController:[[MENavigationController alloc] initWithRootViewController:[[[self class] alloc] init]] animated:YES completion:^{
        MELog();
    }];
}
- (IBAction)_doneItemAction:(id)sender {
    /**
     Access the view controller that is presenting through `presentingViewController` and have it dismiss. This is the standard way to dismiss a modally presented view controller.
     */
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        MELog();
    }];
}

- (IBAction)_popoverButtonAction:(id)sender {
    /**
     Create a new `UIPopoverController` with a content view controller and display it.
     */
    [self setContentPopoverController:[[UIPopoverController alloc] initWithContentViewController:[[MENavigationController alloc] initWithRootViewController:[[[self class] alloc] init]]]];
    /**
     Set ourselves as the delegate of the `UIPopoverController` so the `UIPopoverControllerDelegate` methods implemented above are called.
     */
    [self.contentPopoverController setDelegate:self];
    /**
     We want the popover arrow to appear on the button that was tapped. The arrow direction does not matter.
     */
    [self.contentPopoverController presentPopoverFromRect:self.popoverButton.bounds inView:self.popoverButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
- (IBAction)_pushButtonAction:(id)sender {
    /**
     Push a view controller onto our containing `UINavigationController`.
     
     You can always access the containing `UINavigationController` through the `navigationController` property.
     */
    [self.navigationController pushViewController:[[[self class] alloc] init] animated:YES];
}

@end
