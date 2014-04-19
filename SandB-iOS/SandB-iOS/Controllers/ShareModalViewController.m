//
//  ShareModalViewController.m
//  SandB-iOS
//
//  Created by Lea Marolt on 4/13/14.
//  Copyright (c) 2014 Grinnell AppDev. All rights reserved.
//

#import "ShareModalViewController.h"
#import "MZFormSheetController.h"
#import <SAMTextView.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>


@interface ShareModalViewController () {
    BOOL *twitterBtnPressed;
    BOOL *fbBtnPressed;
    BOOL *emailBtnPressed;
    BOOL *imgBtnPressed;
}

@end

@implementation ShareModalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.backgroundView.backgroundColor = [UIColor colorWithRed:192.0/255.0 green:180.0/255.0 blue:182.0/255.0 alpha:1.0];
    
    self.characterCount.hidden = YES;
    
    self.commentTextView.delegate = self;
    
    self.accountStore = [[ACAccountStore alloc] init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (IBAction)cancelButtonPressed:(id)sender {
    MZFormSheetController *controller = self.formSheetController;
    [controller mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
}

- (IBAction)shareButtonPressed:(id)sender {
    
    [self.commentTextView resignFirstResponder];

}

- (IBAction)twitterButtonPressed:(id)sender {
    
    self.commentTextView.text = [NSString stringWithFormat:@"%@ %@", self.article.title, self.article.URL];
    
    int numOfChars = [self.commentTextView.text length];
    
    self.characterCount.text = [NSString stringWithFormat:@"%i", 140 - numOfChars];
    if (140-numOfChars < 0) {
        self.characterCount.textColor = [UIColor colorWithRed:140.0/255 green:29.0/255 blue:41.0/255 alpha:1.0];
    }
    self.characterCount.hidden = NO;
    
    // ENABLE SHARING NOW, WHEN SHARE BUTTON PRESSED
    
    if (!twitterBtnPressed) {
        self.twitterButton.tintColor = [UIColor colorWithRed:140.0/255 green:29.0/255 blue:41.0/255 alpha:1.0];
        [self buttonPressed:sender withImage:@"TwitterIcon"];
        twitterBtnPressed = YES;
    }
    else {
        self.twitterButton.tintColor = [UIColor whiteColor];
        [self buttonDepressed:sender withImage:@"TwitterIcon"];
        twitterBtnPressed = NO;
    }
    
    // sends a tweet
    [self tweetWithStatus:self.commentTextView.text];
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    int len = self.commentTextView.text;
    self.characterCount.text = [NSString stringWithFormat:@"%i", 140 - len];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (IBAction)facebookButtonPressed:(id)sender {
    [self buttonPressed:sender withImage:@"FacebookIcon"];
    
    self.commentTextView.text = nil;
    self.commentTextView.placeholder = @"Write comment...";
    self.commentTextView.hidden = NO;
    
    if (!fbBtnPressed) {
        self.facebookIcon.tintColor = [UIColor colorWithRed:140.0/255 green:29.0/255 blue:41.0/255 alpha:1.0];
        [self buttonPressed:sender withImage:@"FacebookIcon"];
        fbBtnPressed = YES;
    }
    else {
        self.facebookIcon.tintColor = [UIColor whiteColor];
        [self buttonDepressed:sender withImage:@"FacebookIcon"];
        fbBtnPressed = NO;
    }
}

- (IBAction)iMessageButtonPressed:(id)sender {
    
    if (!imgBtnPressed) {
        self.iMessageButton.tintColor = [UIColor colorWithRed:140.0/255 green:29.0/255 blue:41.0/255 alpha:1.0];
        [self buttonPressed:sender withImage:@"iMessageIcon"];
        imgBtnPressed = YES;
    }
    else {
        self.iMessageButton.tintColor = [UIColor whiteColor];
        [self buttonDepressed:sender withImage:@"iMessageIcon"];
        imgBtnPressed = NO;
    }
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSString *message = [NSString stringWithFormat:@"Just sent the %@ file to your email. Please check!", self.article.URL];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)emailButtonPressed:(id)sender {
    
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        
        mailViewController.navigationBar.tintColor = [UIColor whiteColor];
        mailViewController.navigationBar.translucent = YES;
        
        mailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        
        [mailViewController setSubject:self.article.title];
        NSString *messageBody = [NSString stringWithFormat:@"<h2>%@</h2></br><img src='%@'></br><a href='%@'>Read more...</a>", self.article.title, self.article.imageSmallURL, self.article.URL];
        [mailViewController setMessageBody:messageBody isHTML:YES];
        [self presentViewController:mailViewController animated:YES completion:nil];
    }
    if (!emailBtnPressed) {
        self.emailButton.tintColor = [UIColor colorWithRed:140.0/255 green:29.0/255 blue:41.0/255 alpha:1.0];
        [self buttonPressed:sender withImage:@"EmailIcon"];
        emailBtnPressed = YES;
    }
    else {
        self.emailButton.tintColor = [UIColor whiteColor];
        [self buttonDepressed:sender withImage:@"EmailIcon"];
        emailBtnPressed = NO;
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) buttonPressed:(UIButton *)button withImage:(NSString *)image {
    
    [button setImage:[[UIImage imageNamed:image]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
}

- (void) buttonDepressed:(UIButton *)button withImage:(NSString *)image {
    
    [button setImage:[[UIImage imageNamed:image]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}

- (void) tweetWithStatus:(NSString *)status {
    ACAccountType *twitterType =
    [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    SLRequestHandler requestHandler =
    ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (responseData) {
            NSInteger statusCode = urlResponse.statusCode;
            if (statusCode >= 200 && statusCode < 300) {
                NSDictionary *postResponseData =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers
                                                  error:NULL];
                NSLog(@"[SUCCESS!] Created Tweet with ID: %@", postResponseData[@"id_str"]);
            }
            else {
                NSLog(@"[ERROR] Server responded: status code %d %@", statusCode,
                      [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
            }
        }
        else {
            NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
        }
    };
    
    ACAccountStoreRequestAccessCompletionHandler accountStoreHandler =
    ^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [self.accountStore accountsWithAccountType:twitterType];
            NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                          @"/1.1/statuses/update.json"];
            NSDictionary *params = @{@"status" : status};
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                    requestMethod:SLRequestMethodPOST
                                                              URL:url
                                                       parameters:params];
            [request setAccount:[accounts lastObject]];
            [request performRequestWithHandler:requestHandler];
        }
        else {
            NSLog(@"[ERROR] An error occurred while asking for user authorization: %@",
                  [error localizedDescription]);
        }
    };
    
    [self.accountStore requestAccessToAccountsWithType:twitterType
                                               options:NULL
                                            completion:accountStoreHandler];
}

@end
