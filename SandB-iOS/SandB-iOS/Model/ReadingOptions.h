//
//  ReadingOptions.h
//  SandB-iOS
//
//  Created by AppDev on 3/7/16.
//  Copyright © 2016 Grinnell AppDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadingOptions : NSObject

@property float fontSize;
@property NSString *fontFamily;
@property BOOL isLightTheme;

+ (instancetype)savedOptions;

@end
