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

@end
