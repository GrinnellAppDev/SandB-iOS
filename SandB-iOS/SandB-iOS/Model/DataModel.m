//
//  DataModel.m
//  SandB-iOS
//
//  Created by Maijid Moujaled on 12/25/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import "DataModel.h"
#import "SandBClient.h"
#import "Cache.h"

@implementation DataModel
{
    int _page;
    int _artsPage;
    int _featuresPage;
    int _communityPage;
    int _sportsPage;
    int _opinionsPage;
    int _categoryPage;
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
        self.categoryArticles = [NSMutableArray new];
        self.featuresArticles = [NSMutableArray new];
        self.artsArticles = [NSMutableArray new];
        self.communityArticles = [NSMutableArray new];
        self.sportArticles = [NSMutableArray new];
        self.opinionsArticles = [NSMutableArray new];
        
        _page = 0;
        _artsPage = 0;
        _communityPage = 0;
        _featuresPage = 0;
        _sportsPage = 0;
        _opinionsPage = 0;
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

- (void)searchArticlesForTerm:(NSString *)searchTerm withCompletionBlock:(FetchArticlesCompletionBlock)completion {
    
    
    [[[DataModel sharedModel] articles] removeAllObjects];
    
    [[SandBClient sharedClient] GET:@"get_search_results/"
                         parameters:@{@"search": searchTerm
                                      }
                            success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                                
                                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                
                                if (httpResponse.statusCode == 200) {
                                    int totalPages = [responseObject[@"pages"] intValue];
                                    
                                    NSArray *articleArray = responseObject[@"posts"];
                                    [articleArray enumerateObjectsUsingBlock:^(NSDictionary *articleDictionary, NSUInteger idx, BOOL *stop) {
                                        
                                        Article *article = [[Article alloc] initWithArticleDictionary:articleDictionary];
                                        
                                        [[[DataModel sharedModel] articles] addObject:article];
                                        
                                    }];
                                    completion([[DataModel sharedModel] articles], nil, totalPages, _page, nil);
                                }
                                
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                
                                completion(nil, nil, 0, 0, error);
                            }];
    
}


- (NSMutableArray *)categoryArrayFromID:(NSNumber *)categoryID
{

    switch ([categoryID integerValue]) {
        case 5:
            return _artsArticles;
            break;
        case 216:
            return _communityArticles;
            break;
        case  6:
            return _featuresArticles;
            break;
        case 4:
            return _opinionsArticles;
            break;
        case 7:
            return _sportArticles;
            break;
    }
    return nil;
}

- (NSMutableArray *)categoryArrayForCategoryName:(NSString *)categoryName
{
    NewsCategory *category = [[[NewsCategories sharedCategories] categoriesByName] objectForKey:categoryName];
    return [self categoryArrayFromID:category.idNum]; 
}


- (void)fetchArticlesForCategory:(NSString *)categoryString withCompletionBlock:(FetchArticlesCompletionBlock)completion {
 
    NewsCategory *category = [[[NewsCategories sharedCategories] categoriesByName] objectForKey:categoryString];
    
    switch ([category.idNum integerValue]) {
        case 5: {
            _artsPage++;
            [self fetchArticlesUsingPage:_artsPage andCategoryID:5 andArray:_artsArticles withCompletionBlock:completion];
            break;
        }
            
        case 216: {
            _communityPage++;
            [self fetchArticlesUsingPage:_communityPage andCategoryID:216 andArray:_communityArticles withCompletionBlock:completion];

            break;
        }
            
        case  6: {
            _featuresPage++;
            [self fetchArticlesUsingPage:_featuresPage andCategoryID:6 andArray:_featuresArticles withCompletionBlock:completion];
            break;
        }
            
        case 4:
            _opinionsPage++;
            [self fetchArticlesUsingPage:_opinionsPage andCategoryID:4 andArray:_opinionsArticles withCompletionBlock:completion];
            break;
        case 7: {
            _sportsPage++;
            [self fetchArticlesUsingPage:_sportsPage andCategoryID:7 andArray:_sportArticles withCompletionBlock:completion];
            break;
        }
            
    }
}

- (void) fetchArticlesUsingPage:(int)page andCategoryID:(int)categoryID andArray:(NSMutableArray *)categoryArticles withCompletionBlock:(FetchArticlesCompletionBlock)completion {
    
    NSMutableArray *newCategoryArticles = [NSMutableArray new];

    [[SandBClient sharedClient] GET:@"get_category_posts/"
                         parameters:@{@"id":@(categoryID),
                                      @"page": @(page)
                                      }
     
                            success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                                
                                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                
                                if (httpResponse.statusCode == 200) {
                                    
                                    int totalPages = [responseObject[@"pages"] intValue];
                                    NSLog(@"res: %@", responseObject);
                                    NSArray *articleArray = responseObject[@"posts"];
                                    [articleArray enumerateObjectsUsingBlock:^(NSDictionary *articleDictionary, NSUInteger idx, BOOL *stop) {
                                        
                                        Article *article = [[Article alloc] initWithArticleDictionary:articleDictionary];
                                        [newCategoryArticles addObject:article];
                                        //[[[DataModel sharedModel] categoryArticles] addObject:article];
                                        [categoryArticles addObject:article];
                                       
                                        
                                    }];
                                    completion(categoryArticles, newCategoryArticles, totalPages, page, nil);
                                }
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                
                                completion(nil, nil, 0, 0, error);
                            }];

}

#pragma mark - Adding to favorites. 

- (void)saveArticle:(Article *)article {
    
    NSMutableSet *favoriteSet = [[Cache sharedCacheModel] loadArchivedObjectWithFileName:@"FavoritedArticles"];
    
    if (!favoriteSet) {
        //Create one!
        favoriteSet = [[NSMutableSet alloc] initWithCapacity:3];
    }
    
    [favoriteSet addObject:article];
    
    // Save it favoritesSet
    [[Cache sharedCacheModel] archiveObject:favoriteSet toFileName:@"FavoritedArticles"];
}


- (NSMutableArray *)savedArticles
{
    NSLog(@"Favoritessssss");
    NSSet *favoriteSet = [[Cache sharedCacheModel] loadArchivedObjectWithFileName:@"FavoritedArticles"];
    NSMutableArray *favoriteArray = [NSMutableArray arrayWithArray:favoriteSet.allObjects];
    NSLog(@"fa: %@", favoriteArray);
    return favoriteArray;
}


@end
