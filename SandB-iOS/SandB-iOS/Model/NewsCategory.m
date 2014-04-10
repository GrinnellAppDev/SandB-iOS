//
//  NewsCategory.m
//  SandB-iOS
//
//  Created by Lea Marolt on 4/10/14.
//  Copyright (c) 2014 Grinnell AppDev. All rights reserved.
//

#import "NewsCategory.h"

@implementation NewsCategory

-(id) categoryWithName:(NSString *) name andColor:(UIColor *) color andId:(NSInteger) idNum andHighlightedColor:(UIColor *) higlighted {
    NewsCategory *cat = [[NewsCategory alloc] init];
    
    [cat setName:name];
    [cat setColor:color];
    [cat setIdNum:idNum];
    [cat setHighlightedColor:higlighted];
    
    return cat;
}

@end
