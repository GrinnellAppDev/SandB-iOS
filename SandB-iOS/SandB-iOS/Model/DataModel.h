//
//  DataModel.h
//  SandB-iOS
//
//  Created by Maijid Moujaled on 12/25/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Article.h"

@interface DataModel : NSObject

typedef void (^FetchArticlesCompletionBlock) (NSMutableArray *articles, NSMutableArray *newArticles, int totalPages, int currentPage,  NSError *error);

@property (nonatomic, strong) NSMutableArray *articles;

+ (DataModel *)sharedModel;
- (void)fetchArticlesWithCompletionBlock:(FetchArticlesCompletionBlock)completion;

@end
