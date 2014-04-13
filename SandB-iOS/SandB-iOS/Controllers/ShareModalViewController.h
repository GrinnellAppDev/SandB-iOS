//
//  ShareModalViewController.h
//  SandB-iOS
//
//  Created by Lea Marolt on 4/13/14.
//  Copyright (c) 2014 Grinnell AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareModalViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *backgroundView;

// METHODS
@property (strong, nonatomic) IBOutlet UIButton *cancelButtonPressed;
@property (strong, nonatomic) IBOutlet UIButton *twitterButtonPressed;
@property (strong, nonatomic) IBOutlet UIButton *facebookButtonPressed;
@property (strong, nonatomic) IBOutlet UIButton *iMessageButtonPressed;
@property (strong, nonatomic) IBOutlet UIButton *emailButtonPressed;
@property (strong, nonatomic) IBOutlet UIButton *shareButtonPressed;


@end
