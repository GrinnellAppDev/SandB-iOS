//
//  ShareModalViewController.h
//  SandB-iOS
//
//  Created by Lea Marolt on 4/13/14.
//  Copyright (c) 2014 Grinnell AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZFormSheetController.h"

@interface ShareModalViewController : UIViewController

// PROPERTIES
@property (nonatomic, strong) NSString *articleTitle;

// OUTLETS
@property (strong, nonatomic) IBOutlet UIView *backgroundView;

// BUTTONS
@property (strong, nonatomic) IBOutlet UIButton *twitterButton;
@property (strong, nonatomic) IBOutlet UIButton *facebookIcon;
@property (strong, nonatomic) IBOutlet UIButton *iMessageButton;
@property (strong, nonatomic) IBOutlet UIButton *emailButton;

// METHODS
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;
- (IBAction)twitterButtonPressed:(id)sender;
- (IBAction)facebookButtonPressed:(id)sender;
- (IBAction)iMessageButtonPressed:(id)sender;
- (IBAction)emailButtonPressed:(id)sender;



@end
