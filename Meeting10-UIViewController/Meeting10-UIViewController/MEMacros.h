//
//  MEMacros.h
//  Meeting10-UIViewController
//
//  Created by William Towe on 2/19/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#ifndef Meeting10_UIViewController_MEMacros_h
#define Meeting10_UIViewController_MEMacros_h

#define MELog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#endif
