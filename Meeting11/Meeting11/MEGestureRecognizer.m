//
//  MEGestureRecognizer.m
//  Meeting11
//
//  Created by William Towe on 3/17/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "MEGestureRecognizer.h"

#import <UIKit/UIGestureRecognizerSubclass.h>

@interface MEGestureRecognizer ()
@property (assign,nonatomic) CGPoint startPoint;
@property (assign,nonatomic) CGPoint delta;
@end

@implementation MEGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action {
    if (!(self = [super initWithTarget:target action:action]))
        return nil;
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self setStartPoint:[(UITouch *)touches.anyObject locationInView:self.view]];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    CGPoint location = [(UITouch *)touches.anyObject locationInView:self.view];
    
    [self setDelta:CGPointMake(location.x - self.startPoint.x, location.y - self.startPoint.y)];
    
    if (ABS(self.delta.x) > self.minimumRequiredDistance ||
        ABS(self.delta.y) > self.minimumRequiredDistance) {
        
        [self setState:UIGestureRecognizerStateRecognized];
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    if (ABS(self.delta.x) > self.minimumRequiredDistance ||
        ABS(self.delta.y) > self.minimumRequiredDistance) {
        
        [self setState:UIGestureRecognizerStateRecognized];
    }
    else {
        [self setState:UIGestureRecognizerStateFailed];
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    
    [self setState:UIGestureRecognizerStateFailed];
}

- (void)reset {
    [super reset];
    
    [self setState:UIGestureRecognizerStatePossible];
    [self setStartPoint:CGPointZero];
    [self setDelta:CGPointZero];
}

@end
