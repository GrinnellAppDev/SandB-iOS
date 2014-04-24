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
    if ([self bitlifyMyLink:self.article.URL]) {
        self.commentTextView.text = [NSString stringWithFormat:@"%@ %@", self.article.title, [self bitlifyMyLink:self.article.URL]];
    }
    else {
        self.commentTextView.text = [NSString stringWithFormat:@"%@ %@", self.article.title, self.article.URL];
    }
    
}

- (IBAction)cancelButtonPressed:(id)sender {
    MZFormSheetController *controller = self.formSheetController;
    [controller mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
}


- (IBAction)twitterButtonPressed:(id)sender {
    
    self.characterCount.hidden = NO;
    
    int numOfChars = [self.commentTextView.text length];
    
    self.characterCount.text = [NSString stringWithFormat:@"%i", 140 - numOfChars];
    if (140-numOfChars < 0) {
        self.characterCount.textColor = [UIColor colorWithRed:140.0/255 green:29.0/255 blue:41.0/255 alpha:1.0];
    }
    self.characterCount.hidden = NO;
    
    // ENABLE SHARING NOW, WHEN SHARE BUTTON PRESSED
    
    [self depressButtonsExceptFor:sender];
    
    twitterBtnPressed = YES;
    fbBtnPressed = NO;
    emailBtnPressed = NO;
    imgBtnPressed = NO;

}

-(void)textViewDidChange:(UITextView *)textView
{
    int len = [self.commentTextView.text length];
    NSLog(@"the length: %i", len);
    self.characterCount.text = [NSString stringWithFormat:@"%i", 140 - len];
    if (len > 139) {
        [textView resignFirstResponder];
    }
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if([text length] == 0)
//    {
//        if([textView.text length] != 0)
//        {
//            return YES;
//        }
//    }
//    else if([[textView text] length] > 139)
//    {
//        return NO;
//    }
//    return YES;
//}

- (IBAction)facebookButtonPressed:(id)sender {
    [self buttonPressed:sender withImage:@"FacebookIcon"];
    
    self.commentTextView.text = [NSString stringWithFormat:@"%@", self.article.title];
    //self.commentTextView.text = nil;
    //self.commentTextView.placeholder = @"Add comment...";
    self.commentTextView.hidden = NO;
    
    self.characterCount.hidden = YES;
    
    [self depressButtonsExceptFor:sender];
    
    twitterBtnPressed = NO;
    fbBtnPressed = YES;
    emailBtnPressed = NO;
    imgBtnPressed = NO;

}

- (IBAction)iMessageButtonPressed:(id)sender {
    
    [self depressButtonsExceptFor:sender];
    
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
    
    twitterBtnPressed = NO;
    fbBtnPressed = NO;
    emailBtnPressed = NO;
    imgBtnPressed = YES;

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
    
    MZFormSheetController *ctrl = self.formSheetController;
    [ctrl mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
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
    
    twitterBtnPressed = NO;
    fbBtnPressed = NO;
    emailBtnPressed = YES;
    imgBtnPressed = NO;

    
    [self depressButtonsExceptFor:sender];
}

- (IBAction)shareButtonPressed:(id)sender {
    
    if (twitterBtnPressed) {
        [self tweetWithStatus:self.commentTextView.text];
    }
    
    if (fbBtnPressed) {
        [self postWithStatus:self.commentTextView.text];
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    MZFormSheetController *ctrl = self.formSheetController;
    [ctrl mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
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

- (BOOL) textView: (UITextView*) textView shouldChangeTextInRange: (NSRange) range
  replacementText: (NSString*) text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void) depressButtonsExceptFor:(UIButton *)currentButton {
    
    NSArray *buttons = [[NSArray alloc] initWithObjects:self.twitterButton, self.emailButton, self.facebookIcon, self.iMessageButton, nil];
    
    
    for (UIButton *btn in buttons) {
        if (![btn isEqual:currentButton]) {
        btn.tintColor = [UIColor whiteColor];
            [btn setImage:[btn.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        }
        else {
            btn.tintColor = [UIColor colorWithRed:140.0/255 green:29.0/255 blue:41.0/255 alpha:1.0];
            [btn setImage:[btn.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        }

    }
}

#pragma SOCIAL MEDIA

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
    
    MZFormSheetController *ctrl = self.formSheetController;
    [ctrl mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
}

- (void)postWithStatus:(NSString *)status {
    ACAccountType *facebookType =
    [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSDictionary *options1 = @{ACFacebookAppIdKey : @"692222060836413",
                              ACFacebookPermissionsKey : @[@"email"],
                              ACFacebookAudienceKey:ACFacebookAudienceFriends};
    
    NSDictionary *options2 = @{ACFacebookAppIdKey : @"692222060836413",
                               ACFacebookPermissionsKey : @[@"publish_stream"],
                               ACFacebookAudienceKey:ACFacebookAudienceFriends};
    
    [self.accountStore requestAccessToAccountsWithType:facebookType options:options1
                                            completion:^(BOOL granted, NSError *error) {
                                                if (granted)
                                                {
                                                    NSArray *accounts = [self.accountStore accountsWithAccountType:facebookType];
                                                    
                                                    // Optionally save the account
                                                    [self.accountStore saveAccount:[accounts lastObject] withCompletionHandler:nil];
                                                    
                                                    NSLog(@"email was granted");
                                                } else {
                                                    NSLog(@"%@",error);
                                                    // Fail gracefully...
                                                }
                                            }];
    
    [self.accountStore requestAccessToAccountsWithType:facebookType options:options2
                                            completion:^(BOOL granted, NSError *error) {
                                                if (granted)
                                                {
                                                    NSArray *accounts = [self.accountStore accountsWithAccountType:facebookType];
                                                    
                                                    // Optionally save the account
                                                    [self.accountStore saveAccount:[accounts lastObject] withCompletionHandler:nil];
                                                    
                                                    NSLog(@"publish stream was granted");
                                                } else {
                                                    NSLog(@"%@",error);
                                                    // Fail gracefully...
                                                }
                                            }];
    
    // First obtain the Facebook account from the ACAccountStore
    ACAccountType *accountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    NSArray *accounts = [_accountStore accountsWithAccountType:accountType];
    
    // If we don't have access to users Facebook account, the account store will return an empty array.
    if (accounts.count == 0)
        return;
    
    // Since there's only one Facebook account, grab the last object
    ACAccount *account = [accounts lastObject];
    
    // Create the parameters dictionary and the URL (!use HTTPS!)
    NSDictionary *parameters = @{@"message" : self.commentTextView.text, @"link": self.article.URL};
    NSURL *URL = [NSURL URLWithString:@"https://graph.facebook.com/me/feed"];
    
    // Create request
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                            requestMethod:SLRequestMethodPOST
                                                      URL:URL
                                               parameters:parameters];
    
    // Since we are performing a method that requires authorization we can simply
    // add the ACAccount to the SLRequest
    [request setAccount:account];
    
    // Perform request
    [request performRequestWithHandler:^(NSData *respData, NSHTTPURLResponse *urlResp, NSError *error) {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:respData
                                                                           options:kNilOptions
                                                                             error:&error];
        
        // Check for errors in the responseDictionary
    }];

    MZFormSheetController *ctrl = self.formSheetController;
    [ctrl mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];

}

-(NSString *)bitlifyMyLink:(NSString *)myUrl {
    
    NSString *loginId = @"o_7kd3981uea";
    NSString *apiKey = @"R_746a0d09c127163df1ad0243e6369b35";
    
    NSString *longURL = [NSString stringWithFormat:@"http://api.bit.ly/v3/shorten?login=%@&apikey=%@&longUrl=%@&format=txt",loginId, apiKey, myUrl];
    
    NSString *shortenedURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:longURL] encoding:NSUTF8StringEncoding error:nil];
    
    return shortenedURL;
}

@end
