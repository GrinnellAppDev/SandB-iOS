//
//  NewsCategories.m
//  SandB-iOS
//
//  Created by Lea Marolt on 4/10/14.
//  Copyright (c) 2014 Grinnell AppDev. All rights reserved.
//

#import "NewsCategories.h"

@implementation NewsCategories

+ (NewsCategories *)sharedCategories {
    static NewsCategories *_sharedCategories = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCategories = [[NewsCategories alloc] init];
        // YAY, now I don't have to call it ever!!! Thanks DrJid.
        [_sharedCategories categoriesWithData];
    });
    
    return _sharedCategories;
}

-(void)categoriesWithData {
    
    NSArray *categoryNames = @[@"News", @"Arts", @"Community", @"Features", @"Opinion", @"Sports"];
    NSArray *categoryColors = [[NSArray alloc] initWithObjects:[UIColor colorWithRed:140.0/255 green:29.0/255 blue:41.0/255 alpha:1.0], [UIColor colorWithRed:24.0/255 green:84.0/255 blue:2.0/255 alpha:1.0], [UIColor colorWithRed:139.0/255 green:87.0/255 blue:42.0/255 alpha:1.0], [UIColor colorWithRed:196.0/255 green:22.0/255 blue:22.0/255 alpha:1.0], [UIColor colorWithRed:166.0/255 green:163.0/255 blue:17.0/255 alpha:1.0], [UIColor colorWithRed:40.0/255 green:141.0/255 blue:20.0/255 alpha:1.0], nil];
    NSArray *categoryIds = @[@3, @5, @216, @6, @4, @7];
    NSArray *categoryHighlightedColors = [[NSArray alloc] initWithObjects:[UIColor colorWithRed:140.0/255 green:29.0/255 blue:41.0/255 alpha:0.05], [UIColor colorWithRed:24.0/255 green:84.0/255 blue:2.0/255 alpha:0.05], [UIColor colorWithRed:139.0/255 green:87.0/255 blue:42.0/255 alpha:0.05], [UIColor colorWithRed:196.0/255 green:22.0/255 blue:22.0/255 alpha:0.01], [UIColor colorWithRed:166.0/255 green:163.0/255 blue:17.0/255 alpha:0.05], [UIColor colorWithRed:40.0/255 green:141.0/255 blue:20.0/255 alpha:0.05], nil];
    
    NSArray *barHighlightedColors = [[NSArray alloc] initWithObjects:[UIColor colorWithRed:140.0/255 green:29.0/255 blue:41.0/255 alpha:0.5], [UIColor colorWithRed:24.0/255 green:84.0/255 blue:2.0/255 alpha:0.5], [UIColor colorWithRed:139.0/255 green:87.0/255 blue:42.0/255 alpha:0.5], [UIColor colorWithRed:196.0/255 green:22.0/255 blue:22.0/255 alpha:0.5], [UIColor colorWithRed:166.0/255 green:163.0/255 blue:17.0/255 alpha:0.5], [UIColor colorWithRed:40.0/255 green:141.0/255 blue:20.0/255 alpha:0.5], nil];
    
    _categoriesByName = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < [categoryNames count]; i++) {
        NewsCategory *cat = [[NewsCategory alloc] categoryWithName:categoryNames[i] andColor:categoryColors[i] andId:categoryIds[i] andHighlightedColor:categoryHighlightedColors[i] andReadBarColor:barHighlightedColors[i]];
        //NSLog(@"cat!!: %@", cat);
        [_categoriesByName setObject:cat forKey:cat.name];
    }
    
    
    _categories = [[NSMutableDictionary alloc] init];
    [_categories setObject:categoryNames forKey:@"names"];
    [_categories setObject:categoryColors forKey:@"colors"];
    [_categories setObject:categoryIds forKey:@"ids"];
    [_categories setObject:categoryHighlightedColors forKey:@"highlighted"];
    [_categories setObject:barHighlightedColors forKey:@"readbars"];
}

@end
