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
    int page;
    int artsPage;
    int featuresPage;
    int communityPage;
    int sportsPage;
    int opinionsPage;
    int categoryPage;
    int unsortedPage;
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
        self.unsortedArticles = [NSMutableArray new];
        
        page = 0;
        artsPage = 0;
        communityPage = 0;
        featuresPage = 0;
        sportsPage = 0;
        opinionsPage = 0;
        unsortedPage = 0;
    }
    return self;
}



- (void)fetchArticlesWithCompletionBlock:(FetchArticlesCompletionBlock)completion
{
    
    
    page++;
    NSMutableArray *newArticles = [NSMutableArray new];
    
    
    [[SandBClient sharedClient] GET:@"get_recent_posts/"
                         parameters:@{@"count": @(12),
                                      @"page": @(page)
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
                                    completion([[DataModel sharedModel] articles], newArticles, totalPages, page, nil);
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
                                    completion([[DataModel sharedModel] articles], nil, totalPages, page, nil);
                                }
                                
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                
                                completion(nil, nil, 0, 0, error);
                            }];
    
}


- (NSMutableArray *)categoryArrayFromID:(NSNumber *)categoryID
{
    
    switch ([categoryID integerValue]) {
        case 5:
            return self.artsArticles;
            break;
        case 216:
            return self.communityArticles;
            break;
        case  6:
            return self.featuresArticles;
            break;
        case 4:
            return self.opinionsArticles;
            break;
        case 7:
            return self.sportArticles;
            break;
        case 1:
            return self.unsortedArticles;
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
            artsPage++;
            [self fetchArticlesUsingPage:artsPage andCategoryID:5 andArray:self.artsArticles withCompletionBlock:completion];
            break;
        }
            
        case 216: {
            communityPage++;
            [self fetchArticlesUsingPage:communityPage andCategoryID:216 andArray:self.communityArticles withCompletionBlock:completion];
            
            break;
        }
            
        case  6: {
            featuresPage++;
            [self fetchArticlesUsingPage:featuresPage andCategoryID:6 andArray:self.featuresArticles withCompletionBlock:completion];
            break;
        }
            
        case 4:
            opinionsPage++;
            [self fetchArticlesUsingPage:opinionsPage andCategoryID:4 andArray:self.opinionsArticles withCompletionBlock:completion];
            break;
        case 7: {
            sportsPage++;
            [self fetchArticlesUsingPage:sportsPage andCategoryID:7 andArray:self.sportArticles withCompletionBlock:completion];
            break;
        }
        case 1: {
            unsortedPage++;
            [self fetchArticlesUsingPage:unsortedPage andCategoryID:1 andArray:self.unsortedArticles withCompletionBlock:completion];
            break;
        }
            
    }
}

- (void) fetchArticlesUsingPage:(int)thePage andCategoryID:(int)categoryID andArray:(NSMutableArray *)categoryArticles withCompletionBlock:(FetchArticlesCompletionBlock)completion {
    
    NSMutableArray *newCategoryArticles = [NSMutableArray new];
    
    [[SandBClient sharedClient] GET:@"get_category_posts/"
                         parameters:@{@"id":@(categoryID),
                                      @"page": @(thePage)
                                      }
     
                            success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                                
                                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                
                                if (httpResponse.statusCode == 200) {
                                    
                                    int totalPages = [responseObject[@"pages"] intValue];
                                    //NSLog(@"res: %@", responseObject);
                                    NSArray *articleArray = responseObject[@"posts"];
                                    [articleArray enumerateObjectsUsingBlock:^(NSDictionary *articleDictionary, NSUInteger idx, BOOL *stop) {
                                        
                                        Article *article = [[Article alloc] initWithArticleDictionary:articleDictionary];
                                        [newCategoryArticles addObject:article];
                                        //[[[DataModel sharedModel] categoryArticles] addObject:article];
                                        [categoryArticles addObject:article];
                                        
                                        
                                    }];
                                    completion(categoryArticles, newCategoryArticles, totalPages, thePage, nil);
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
    
    article.favorited = YES;
    
    [favoriteSet addObject:article];
    
    // Save it favoritesSet
    [[Cache sharedCacheModel] archiveObject:favoriteSet toFileName:@"FavoritedArticles"];
}

- (void) deleteArticle:(Article *) article {
    NSMutableSet *favoriteSet = [[Cache sharedCacheModel] loadArchivedObjectWithFileName:@"FavoritedArticles"];
    
    if (!favoriteSet) {
        //Create one!
        favoriteSet = [[NSMutableSet alloc] initWithCapacity:3];
    }
    
    article.favorited = NO;
    
    [favoriteSet removeObject:article];
    
    // Save it favoritesSet
    [[Cache sharedCacheModel] archiveObject:favoriteSet toFileName:@"FavoritedArticles"];
}


- (NSMutableArray *)savedArticles
{
    //NSLog(@"Favoritessssss");
    NSSet *favoriteSet = [[Cache sharedCacheModel] loadArchivedObjectWithFileName:@"FavoritedArticles"];
    NSMutableArray *favoriteArray = [NSMutableArray arrayWithArray:favoriteSet.allObjects];
    //NSLog(@"fa: %@", favoriteArray);
    return favoriteArray;
}


#pragma mark - Marking articles as read
- (void)markArticleAsRead:(Article *)article
{
    article.read = YES;
    
    NSMutableSet *readArticles = [[Cache sharedCacheModel] loadArchivedObjectWithFileName:@"ReadArticles"];
    
    if (!readArticles) {
        //Create one!
        readArticles = [[NSMutableSet alloc] initWithCapacity:3];
    }
    
    [readArticles addObject:article];
    
    // Save it favoritesSet
    [[Cache sharedCacheModel] archiveObject:readArticles toFileName:@"ReadArticles"];
    
}

- (NSMutableSet *)favoritedArticles
{
    NSMutableSet *readArticles = [[Cache sharedCacheModel] loadArchivedObjectWithFileName:@"FavoritedArticles"];
    return readArticles;
}

- (NSMutableSet *)readArticles
{
    NSMutableSet *readArticles = [[Cache sharedCacheModel] loadArchivedObjectWithFileName:@"ReadArticles"];
    return readArticles;
}



@end