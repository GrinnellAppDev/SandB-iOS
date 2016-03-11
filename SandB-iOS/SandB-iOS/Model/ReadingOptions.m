//
//  ReadingOptions.m
//  SandB-iOS
//
//  Created by AppDev on 3/7/16.
//  Copyright © 2016 Grinnell AppDev. All rights reserved.
//

#import "ReadingOptions.h"

@implementation ReadingOptions

+ (instancetype)savedOptions
{
    ReadingOptions *options = [[ReadingOptions alloc] init];
    
    options.fontSize = [[NSUserDefaults standardUserDefaults] floatForKey:@"ReadingOptionsFontSize"];
    options.fontFamily = [[NSUserDefaults standardUserDefaults] stringForKey:@"ReadingOptionsFontFamily"];
    options.isLightTheme = [[NSUserDefaults standardUserDefaults] boolForKey:@"ReadingOptionsIsLightTheme"];
    
    return options;
}

@end
