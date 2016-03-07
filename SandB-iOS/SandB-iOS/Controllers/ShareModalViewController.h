
#import <Accounts/Accounts.h>
#import <MessageUI/MessageUI.h>
#import <SAMTextView.h>
#import <UIKit/UIKit.h>

@class Article;

@interface ShareModalViewController : UIViewController <MFMailComposeViewControllerDelegate, UITextViewDelegate, MFMessageComposeViewControllerDelegate>

// PROPERTIES
@property (nonatomic, strong) Article *article;
@property (nonatomic, strong) ACAccount *twitterAccount;
@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) ACAccount *facebookAccount;

// OUTLETS
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet SAMTextView *commentTextView;
@property (strong, nonatomic) IBOutlet UILabel *characterCount;
@property (weak, nonatomic) IBOutlet UIView *postedScreen;

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
