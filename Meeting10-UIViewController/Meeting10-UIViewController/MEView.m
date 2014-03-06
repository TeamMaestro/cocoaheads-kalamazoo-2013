//
//  MEView.m
//  Meeting10-UIViewController
//
//  Created by William Towe on 2/20/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "MEView.h"
#import "UIColor+MEExtensions.h"

#import <QuartzCore/QuartzCore.h>

@interface MEView ()
@property (strong,nonatomic) UIView *circleView;

- (void)_MEView_init;
@end

@implementation MEView
#pragma mark *** Subclass Overrides ***
#pragma mark Initialization
/**
 Called when a custom view is created in code.
 */
- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self _MEView_init];
    
    return self;
}
#pragma mark NSCoding
/**
 Called when a custom view is created in Inteface Builder using a .xib or .storyboard file.
 */
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    [self _MEView_init];
    
    return self;
}
#pragma mark Containment
/**
 Called when the receiver is about to move to a new window or nil, indicating it is about to be removed from the visible view hierarchy.
 */
- (void)willMoveToWindow:(UIWindow *)newWindow {
    MELog();
}
/**
 Called when the receiver is about to move to a new superview or nil.
 
 *NOTE:* Even is _newSuperview_ is non-nil, it does mean the view is visible.
 */
- (void)willMoveToSuperview:(UIView *)newSuperview {
    MELog();
}
/**
 Called right after the receiver moves to a new window.
 
 *NOTE:* The receiver will be visible if `window` is non-nil.
 */
- (void)didMoveToWindow {
    MELog();
}
/**
 Called right after the receiver moves to a new superview.
 
 *NOTE:* The receiver may not be visible even if `superview` is non-nil. Rely on the value of `window` to determine visibilty.
 */
- (void)didMoveToSuperview {
    MELog();
}
/**
 Called right before any subview is removed from the receiver.
 */
- (void)willRemoveSubview:(UIView *)subview {
    MELog(@"%@",subview);
}
/**
 Call right after any subview is added to the receiver.
 */
- (void)didAddSubview:(UIView *)subview {
    MELog(@"%@",subview);
}
#pragma mark Layout
/**
 Called whenever the receiver's `frame` changes and it needs to layout its subviews.
 */
- (void)layoutSubviews {
    CGFloat const kInset = 25;
    
    /**
     We only have one subview so set its `frame` and we are done.
     */
    [self.circleView setFrame:CGRectInset(self.bounds, kInset, kInset)];
    
    MELog();
}
#pragma mark Sizing
/**
 Affects how the receiver is sized when `sizeToFit` is called.
 
 The receiver should compute its mimimum size and return it from this method.
 */
- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(150, 100);
}
#pragma mark *** Private Methods ***
- (void)_MEView_init; {
    /**
     Set our background color to something random.
     */
    [self setBackgroundColor:[UIColor ME_colorWithHexadecimalString:[NSString stringWithFormat:@"%p",self]]];
    
    /**
     Create our only subview and add it to the view hierarchy.
     */
    [self setCircleView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.circleView setBackgroundColor:[UIColor ME_colorWithHexadecimalString:[NSString stringWithFormat:@"%p",self.circleView]]];
    [self addSubview:self.circleView];
}

@end
