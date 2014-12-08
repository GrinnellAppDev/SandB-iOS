//
//  NSString+ISO8859Codes.h
//  SandB-iOS
//
//  Created by Maijid Moujaled on 4/13/14.
//  Copyright (c) 2014 Grinnell AppDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ISO8859Codes)
- (NSString *)stringByDecodingXMLEntities;
@end
