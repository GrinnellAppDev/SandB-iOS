//
//  GlassViewController.h
//  SandB-iOS
//
//  Created by Maijid Moujaled on 12/23/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//
//  Much of this code borrowed heavily from BTGlassScrollView. Modified to use storyboards and take advantage of
//  autolayout.

#import <UIKit/UIKit.h>
#import "BTGlassScrollView.h"

@interface GlassViewController : UIViewController <UIScrollViewAccessibilityDelegate>

@property (nonatomic, strong) NSMutableArray *articles; 

@end

