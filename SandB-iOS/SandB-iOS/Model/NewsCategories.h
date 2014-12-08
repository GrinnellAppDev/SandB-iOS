//
//  NewsCategories.h
//  SandB-iOS
//
//  Created by Lea Marolt on 4/10/14.
//  Copyright (c) 2014 Grinnell AppDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsCategory.h"

@interface NewsCategories : NSObject

@property (nonatomic, strong) NSMutableDictionary *categories;
@property (nonatomic, strong) NSMutableDictionary *categoriesByName;

+(NewsCategories *) sharedCategories;
-(void) categoriesWithData;

@end
