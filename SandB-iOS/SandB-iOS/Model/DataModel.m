//
//  DataModel.m
//  SandB-iOS
//
//  Created by Maijid Moujaled on 12/25/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import "DataModel.h"
#import "SandBClient.h"

@implementation DataModel
{
    int _page;
}


+ (DataModel *)sharedModel {
    static DataModel *_sharedModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[DataModel alloc] init];
    });
    
    return _sharedModel;
}
- (id)init
{
    self  = [super init];
    if (self) {
        self.articles = [NSMutableArray new];
        _page = 0;
        
    }
    return self;
}


- (void)fetchArticlesWithCompletionBlock:(FetchArticlesCompletionBlock)completion
{
    _page++;
    NSMutableArray *newArticles = [NSMutableArray new];

    [[SandBClient sharedClient] GET:@"get_recent_posts/"
                         parameters:@{@"count": @(12),
                                      @"page": @(_page)
                                      }
                            success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                                
                                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                
                                if (httpResponse.statusCode == 200) {
                                    int totalPages = [responseObject[@"pages"] intValue];
                                    NSArray *articleArray = responseObject[@"posts"];
                                    [articleArray enumerateObjectsUsingBlock:^(NSDictionary *articleDictionary, NSUInteger idx, BOOL *stop) {
                                        
                                        Article *article = [[Article alloc] initWithArticleDictionary:articleDictionary];
                                        [newArticles addObject:article];
                                        [[[DataModel sharedModel] articles] addObject:article];
                                    }];
                                    completion([[DataModel sharedModel] articles], newArticles, totalPages, _page, nil);
                                }
                                
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {

                                completion(nil, nil, 0, 0, error);
                            }];
}



@end
