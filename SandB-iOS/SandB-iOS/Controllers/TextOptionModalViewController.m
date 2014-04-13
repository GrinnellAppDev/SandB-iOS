//
//  TextOptionModalViewController.m
//  SandB-iOS
//
//  Created by Lea Marolt on 4/13/14.
//  Copyright (c) 2014 Grinnell AppDev. All rights reserved.
//

#import "TextOptionModalViewController.h"
#import "MZFormSheetController.h"

@interface TextOptionModalViewController ()

@end

@implementation TextOptionModalViewController

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
    
    self.view.backgroundColor = [UIColor colorWithRed:192.0/255.0 green:180.0/255.0 blue:182.0/255.0 alpha:1.0];
    
    self.textSlider.maximumTrackTintColor = [UIColor whiteColor];
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

- (IBAction)sentinelFontButtonPressed:(id)sender {
}

- (IBAction)helveticaFontButtonPressed:(id)sender {
}

- (IBAction)ubuntuFontButtonPressed:(id)sender {
}

- (IBAction)lightThemeButtonPressed:(id)sender {
}

- (IBAction)darkThemeButtonPressed:(id)sender {
}
@end
