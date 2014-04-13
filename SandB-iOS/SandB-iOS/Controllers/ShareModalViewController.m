//
//  ShareModalViewController.m
//  SandB-iOS
//
//  Created by Lea Marolt on 4/13/14.
//  Copyright (c) 2014 Grinnell AppDev. All rights reserved.
//

#import "ShareModalViewController.h"
#import "MZFormSheetController.h"

@interface ShareModalViewController () {
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelButtonPressed:(id)sender {
    MZFormSheetController *controller = self.formSheetController;
    [controller mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
}

- (IBAction)shareButtonPressed:(id)sender {

}

- (IBAction)twitterButtonPressed:(id)sender {
}

- (IBAction)facebookButtonPressed:(id)sender {
}

- (IBAction)iMessageButtonPressed:(id)sender {
}
- (IBAction)emailButtonPressed:(id)sender {
}
@end
