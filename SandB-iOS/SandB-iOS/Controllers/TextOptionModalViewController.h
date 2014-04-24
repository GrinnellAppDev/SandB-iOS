//
//  TextOptionModalViewController.h
//  SandB-iOS
//
//  Created by Lea Marolt on 4/13/14.
//  Copyright (c) 2014 Grinnell AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface TextOptionModalViewController : UIViewController

// PROPERTIES
@property (strong, nonatomic) IBOutlet UISlider *textSlider;
@property (strong, nonatomic) IBOutlet UIButton *sentinelFontButton;
@property (strong, nonatomic) IBOutlet UIButton *helveticaFontButton;
@property (strong, nonatomic) IBOutlet UIButton *ubuntuFontButton;

// METHODS
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)sentinelFontButtonPressed:(id)sender;
- (IBAction)helveticaFontButtonPressed:(id)sender;
- (IBAction)ubuntuFontButtonPressed:(id)sender;



@end
