//
//  ShareModalViewController.h
//  SandB-iOS
//
//  Created by Lea Marolt on 4/13/14.
//  Copyright (c) 2014 Grinnell AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZFormSheetController.h"
#import "Article.h"
#import <MessageUI/MessageUI.h>
#import <SAMTextView.h>
#import <Accounts/Accounts.h>

@interface ShareModalViewController : UIViewController <MFMailComposeViewControllerDelegate, UITextViewDelegate, MFMessageComposeViewControllerDelegate>

// PROPERTIES
@property (nonatomic, strong) Article *article;
@property (nonatomic, strong) ACAccount *twitterAccount;
@property (nonatomic, strong) ACAccountStore *accountStore;

// OUTLETS
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet SAMTextView *commentTextView;
@property (strong, nonatomic) IBOutlet UILabel *characterCount;

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
