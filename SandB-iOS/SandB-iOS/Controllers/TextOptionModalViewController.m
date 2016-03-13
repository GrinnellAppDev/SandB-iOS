
#import "Article.h"
#import "MZFormSheetController.h"
#import "TextOptionModalViewController.h"

@interface TextOptionModalViewController ()

@property (nonatomic, strong) NSString *fontFamily;

@end

@implementation TextOptionModalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:192.0/255.0
                                                green:180.0/255.0
                                                 blue:182.0/255.0
                                                alpha:1.0];
    
    self.textSlider.maximumTrackTintColor = [UIColor whiteColor];
    
    // Set the initial values.
    float fontSize = [[NSUserDefaults standardUserDefaults] floatForKey:@"ReadingOptionsFontSize"];
    
    self.textSlider.value = fontSize;
    
    [self colorChosenFont];
    
    // TODO (DrJid): Set the current Font family and highlight that button as selected.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReadingOptionsDismissed"
                                                        object:nil];
}

- (IBAction)cancelButtonPressed:(id)sender
{
    MZFormSheetController *controller = self.formSheetController;
    [controller mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
}

//     // Helvetica Neue || Avenir Next || Cochin


- (IBAction)sentinelFontButtonPressed:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"ProximaNova-Light"
                                              forKey:@"ReadingOptionsFontFamily"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self changeButton:sender toColor:[UIColor colorWithRed:140.0/255
                                                      green:29.0/255
                                                       blue:41.0/255
                                                      alpha:1.0]];
    
    [self changeButton:self.ubuntuFontButton toColor:[UIColor whiteColor]];
    [self changeButton:self.helveticaFontButton toColor:[UIColor whiteColor]];
    
}

- (IBAction)helveticaFontButtonPressed:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"HelveticaNeue-Light"
                                              forKey:@"ReadingOptionsFontFamily"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [self changeButton:sender toColor:[UIColor colorWithRed:140.0/255
                                                      green:29.0/255
                                                       blue:41.0/255
                                                      alpha:1.0]];
    
    [self changeButton:self.ubuntuFontButton toColor:[UIColor whiteColor]];
    [self changeButton:self.sentinelFontButton toColor:[UIColor whiteColor]];
}

- (IBAction)ubuntuFontButtonPressed:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"Quattrocento"
                                              forKey:@"ReadingOptionsFontFamily"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [self changeButton:sender toColor:[UIColor colorWithRed:140.0/255
                                                      green:29.0/255
                                                       blue:41.0/255
                                                      alpha:1.0]];
    
    [self changeButton:self.sentinelFontButton toColor:[UIColor whiteColor]];
    [self changeButton:self.helveticaFontButton toColor:[UIColor whiteColor]];
}

- (IBAction)fontSizeValueChanged:(UISlider *)slider {
    
    //NSLog(@"sender: %f", slider.value);
    
    [[NSUserDefaults standardUserDefaults] setFloat:slider.value forKey:@"ReadingOptionsFontSize"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) changeButton:(UIButton *)btn toColor:(UIColor *)color {
    btn.tintColor = color;
    
    [btn setImage:[btn.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
         forState:UIControlStateNormal];
}

- (void) colorChosenFont {
    
    self.fontFamily = [[NSUserDefaults standardUserDefaults]
                          objectForKey:@"ReadingOptionsFontFamily"];
    
    if (!self.fontFamily) {
        self.fontFamily = @"HelveticaNeue-Light";
        [self changeButton:self.helveticaFontButton toColor:[UIColor colorWithRed:140.0/255
                                                                            green:29.0/255
                                                                             blue:41.0/255
                                                                            alpha:1.0]];
    }
    
    else if ([self.fontFamily isEqualToString:@"HelveticaNeue-Light"]) {
        
        [self changeButton:self.helveticaFontButton toColor:[UIColor colorWithRed:140.0/255
                                                                            green:29.0/255
                                                                             blue:41.0/255
                                                                            alpha:1.0]];
    }
    
    else if ([self.fontFamily isEqualToString:@"ProximaNova-Light"]) {
        
        [self changeButton:self.sentinelFontButton toColor:[UIColor colorWithRed:140.0/255
                                                                           green:29.0/255
                                                                            blue:41.0/255
                                                                           alpha:1.0]];
    }
    
    else if ([self.fontFamily isEqualToString:@"Quattrocento"]) {
        
        [self changeButton:self.ubuntuFontButton toColor:[UIColor colorWithRed:140.0/255
                                                                         green:29.0/255
                                                                          blue:41.0/255
                                                                         alpha:1.0]];
    }
}
@end
