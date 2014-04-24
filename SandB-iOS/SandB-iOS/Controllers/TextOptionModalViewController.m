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
    
    NSString *fontFamily = [[NSUserDefaults standardUserDefaults] objectForKey:@"ReadingOptionsFontFamily"];
    
    NSLog(@"font family: %@", fontFamily);
    
    if (!fontFamily) {
        fontFamily = @"HelveticaNeue-Light";
        self.helveticaFontButton.tintColor = [UIColor redColor];
        
        self.helveticaFontButton.tintColor = [UIColor colorWithRed:140.0/255 green:29.0/255 blue:41.0/255 alpha:1.0];
        [self.helveticaFontButton setImage:[self.helveticaFontButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
    
    else if ([fontFamily isEqualToString:@"HelveticaNeue-Light"]) {
    
        self.helveticaFontButton.tintColor = [UIColor colorWithRed:140.0/255 green:29.0/255 blue:41.0/255 alpha:1.0];
        [self.helveticaFontButton setImage:[self.helveticaFontButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
    
    else if ([fontFamily isEqualToString:@"ProximaNova-Light"]) {
        
        self.sentinelFontButton.tintColor = [UIColor colorWithRed:140.0/255 green:29.0/255 blue:41.0/255 alpha:1.0];
        [self.helveticaFontButton setImage:[self.sentinelFontButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
    
    else if ([fontFamily isEqualToString:@"Quattrocento"]) {
        
        self.ubuntuFontButton.tintColor = [UIColor colorWithRed:140.0/255 green:29.0/255 blue:41.0/255 alpha:1.0];
        [self.ubuntuFontButton setImage:[self.ubuntuFontButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
    
    self.textSlider.value = fontSize;
    
    // TODO (DrJid): Set the current Font family and highlight that button as selected.
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
    [[NSUserDefaults standardUserDefaults] setObject:@"ProximaNova-Light" forKey:@"ReadingOptionsFontFamily"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.sentinelFontButton.tintColor = [UIColor colorWithRed:140.0/255 green:29.0/255 blue:41.0/255 alpha:1.0];
    [self.sentinelFontButton setImage:[self.sentinelFontButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    self.ubuntuFontButton.tintColor = [UIColor whiteColor];
    [self.ubuntuFontButton setImage:[self.ubuntuFontButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.helveticaFontButton.tintColor = [UIColor whiteColor];
    [self.helveticaFontButton setImage:[self.helveticaFontButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
}

- (IBAction)helveticaFontButtonPressed:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"HelveticaNeue-Light" forKey:@"ReadingOptionsFontFamily"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.helveticaFontButton.tintColor = [UIColor colorWithRed:140.0/255 green:29.0/255 blue:41.0/255 alpha:1.0];
    [self.helveticaFontButton setImage:[self.helveticaFontButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    self.ubuntuFontButton.tintColor = [UIColor whiteColor];
    [self.ubuntuFontButton setImage:[self.ubuntuFontButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.sentinelFontButton.tintColor = [UIColor whiteColor];
    [self.sentinelFontButton setImage:[self.sentinelFontButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
}

- (IBAction)ubuntuFontButtonPressed:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"Quattrocento" forKey:@"ReadingOptionsFontFamily"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.ubuntuFontButton.tintColor = [UIColor colorWithRed:140.0/255 green:29.0/255 blue:41.0/255 alpha:1.0];
    [self.ubuntuFontButton setImage:[self.ubuntuFontButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    self.sentinelFontButton.tintColor = [UIColor whiteColor];
    [self.sentinelFontButton setImage:[self.sentinelFontButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.helveticaFontButton.tintColor = [UIColor whiteColor];
    [self.helveticaFontButton setImage:[self.helveticaFontButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
}

- (IBAction)fontSizeValueChanged:(UISlider *)slider {
    
    NSLog(@"sender: %f", slider.value);
    
    [[NSUserDefaults standardUserDefaults] setFloat:slider.value forKey:@"ReadingOptionsFontSize"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadPageViewController" object:nil];
}
@end
