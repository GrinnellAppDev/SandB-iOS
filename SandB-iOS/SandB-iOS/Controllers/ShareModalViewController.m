
#import <Accounts/Accounts.h>
#import <Social/Social.h>

#import "Article.h"
#import "MBProgressHUD.h"
#import "MZFormSheetController.h"
#import "SAMTextView.h"
#import "ShareModalViewController.h"

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
    
    self.postedScreen.alpha = 0;
    
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
    
    if ([self bitlifyMyLink:self.article.URL]) {
        self.commentTextView.text = [NSString stringWithFormat:@"%@ %@", self.article.title, [self bitlifyMyLink:self.article.URL]];
    }
    else {
        self.commentTextView.text = [NSString stringWithFormat:@"%@ %@", self.article.title, self.article.URL];
    }
    
    int numOfChars = (int)[self.commentTextView.text length];
    
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
    int len = (int)[self.commentTextView.text length];
    //NSLog(@"the length: %i", len);
    self.characterCount.text = [NSString stringWithFormat:@"%i", 140 - len];
    if (len > 139) {
        [textView resignFirstResponder];
    }
}

- (IBAction)facebookButtonPressed:(id)sender {
    [self buttonPressed:sender withImage:@"FacebookIcon"];
    
    self.commentTextView.text = [NSString stringWithFormat:@"%@", self.article.title];
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
    
    NSString *message = [NSString stringWithFormat:@"Check out this awesome article: %@!", self.article.URL];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setBody:message];
    
    [[messageController navigationBar] setTintColor:[UIColor whiteColor]];
    
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
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Sending tweet...";
    [hud show:YES];
    
    SLRequestHandler requestHandler =
    ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (responseData) {
            NSInteger statusCode = urlResponse.statusCode;
            if (statusCode >= 200 && statusCode < 300) {
                
                [hud hide:YES];
                
                NSDictionary *postResponseData =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers
                                                  error:NULL];
                NSLog(@"[SUCCESS!] Created Tweet with ID: %@", postResponseData[@"id_str"]);
                
                [self succesfulPost];
            }
            else {
                [hud hide:YES];
                
                NSLog(@"[ERROR] Server responded: status code %ld %@", (long)statusCode,
                      [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
                
                MZFormSheetController *controller = self.formSheetController;
                [controller mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
                
                [self unsuccesfulPostWithError:[NSString stringWithFormat:@"Server responded, status code %ld %@", (long)statusCode, [NSHTTPURLResponse localizedStringForStatusCode:statusCode]]];
            }
            
        }
        else {
            [hud hide:YES];
            
            NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
            [self unsuccesfulPostWithError:[NSString stringWithFormat:@"An error occurred while posting: %@", [error localizedDescription]]];
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
            
            NSLog(@"Granted!");
        }
        else {
            
            NSLog(@"[ERROR] An error occurred while asking for user authorization: %@",
                  [error localizedDescription]);
            [self unsuccesfulPostWithError:[NSString stringWithFormat:@"An error occurred while asking for user authorization: %@", [error localizedDescription]]];
            
        }
        
    };
    
    [self.accountStore requestAccessToAccountsWithType:twitterType
                                               options:NULL
                                            completion:accountStoreHandler];
    
    
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
                                                    
                                                    [self unsuccesfulPostWithError:[error localizedDescription]];
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
                                                    [self unsuccesfulPostWithError:[error localizedDescription]];
                                                }
                                            }];
    
    // First obtain the Facebook account from the ACAccountStore
    ACAccountType *accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    NSArray *accounts = [self.accountStore accountsWithAccountType:accountType];
    
    // If we don't have access to users Facebook account, the account store will return an empty array.
    if (accounts.count == 0)
        return;
    
    // Since there's only one Facebook account, grab the last object
    self.facebookAccount = [accounts lastObject];
    
    // Create the parameters dictionary and the URL (!use HTTPS!)
    NSDictionary *parameters = @{@"message" : self.commentTextView.text, @"link": self.article.URL};
    //NSURL *URL = [NSURL URLWithString:@"https://graph.facebook.com/me/feed"];
    
    // Create request
//    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
//                                            requestMethod:SLRequestMethodPOST
//                                                      URL:URL
//                                               parameters:parameters];
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                       requestMethod:SLRequestMethodGET
                                                                 URL:[NSURL URLWithString:@"https://graph.facebook.com/me"]
                                                          parameters:@{@"fields": @"feed"}];
    
    // Since we are performing a method that requires authorization we can simply
    // add the ACAccount to the SLRequest
    
    NSLog(@"The parameters: %@", parameters);
    [request setAccount:self.facebookAccount];
    
    
    
    // Perform request
    [request performRequestWithHandler:^(NSData *respData, NSHTTPURLResponse *urlResp, NSError *error) {
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:respData
                                                                           options:kNilOptions
                                                                             error:&error];
        // Check for errors in the responseDictionary
        
        NSLog(@"The response: %@", responseDictionary);
        
        if (error) {
            [self unsuccesfulPostWithError:[error localizedDescription]];
        }
        else {
            [self succesfulPost];
        }
        
    }];

}

-(NSString *)bitlifyMyLink:(NSString *)myUrl {
    
    NSString *loginId = @"o_7kd3981uea";
    NSString *apiKey = @"R_746a0d09c127163df1ad0243e6369b35";
    
    NSString *longURL = [NSString stringWithFormat:@"http://api.bit.ly/v3/shorten?login=%@&apikey=%@&longUrl=%@&format=txt",loginId, apiKey, myUrl];
    
    NSString *shortenedURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:longURL] encoding:NSUTF8StringEncoding error:nil];
    
    return shortenedURL;
}

- (void) succesfulPost {
    [UIView animateWithDuration:0.3
                          delay: 0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.postedScreen.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         // Wait one second and then fade in the view
                         [UIView animateWithDuration:0.3
                                               delay: 0.6
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              self.postedScreen.alpha = 0;
                                              
                                          }
                                          completion:^(BOOL finished){
                                              MZFormSheetController *controller = self.formSheetController;
                                              [controller mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
                                          }];
                     }];
    

}


- (void) unsuccesfulPostWithError:(NSString *) error {
    
    MZFormSheetController *controller = self.formSheetController;
    [controller mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Post unsuccessful!" message:[NSString stringWithFormat:@"Error: %@", error] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    
    [alert show];
    
}

@end
