//
//  MEGuidedTourViewController.h
//  Meeting11
//
//  Created by William Towe on 3/19/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MEGuidedTourViewControllerDataSource;

@interface MEGuidedTourViewController : UIViewController

@property (weak,nonatomic) id<MEGuidedTourViewControllerDataSource> dataSource;

@end

@protocol MEGuidedTourViewControllerDataSource <NSObject>
@required
- (NSArray *)viewsForGuidedTourViewController:(MEGuidedTourViewController *)viewController;
@end