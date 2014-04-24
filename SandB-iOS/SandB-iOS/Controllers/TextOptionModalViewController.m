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
    
    // Set the initial values.
    float fontSize = [[NSUserDefaults standardUserDefaults] floatForKey:@"ReadingOptionsFontSize"];
    
    NSString * fontFamily = [[NSUserDefaults standardUserDefaults] objectForKey:@"ReadingOptionsFontFamily"];
    
    self.textSlider.value = fontSize;
    
    // TODO (DrJid): Set the current Font family and highlight that button as selected.
    
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
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

//     // Helvetica Neue || Avenir Next || Cochin


- (IBAction)sentinelFontButtonPressed:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"Raleway-Regular" forKey:@"ReadingOptionsFontFamily"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (IBAction)helveticaFontButtonPressed:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"Helvetica Neue" forKey:@"ReadingOptionsFontFamily"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)ubuntuFontButtonPressed:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"Avenir Next" forKey:@"ReadingOptionsFontFamily"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)lightThemeButtonPressed:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ReadingOptionsIsLightTheme"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)darkThemeButtonPressed:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ReadingOptionsIsLightTheme"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)fontSizeValueChanged:(UISlider *)slider {
    
    NSLog(@"sender: %f", slider.value);
    
    [[NSUserDefaults standardUserDefaults] setFloat:slider.value forKey:@"ReadingOptionsFontSize"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadPageViewController" object:nil];
}
@end
