
#import <Foundation/Foundation.h>

#import "Article.h"
#import "NewsCategories.h"
#import "NewsCategory.h"

@interface DataModel : NSObject

typedef void (^FetchArticlesCompletionBlock) (NSMutableArray *articles, NSMutableArray *newArticles, int totalPages, int currentPage,  NSError *error);

@property (nonatomic, strong) NSMutableArray *articles;
@property (nonatomic, strong) NSMutableArray *categoryArticles;
@property (nonatomic, strong) NSMutableArray *artsArticles;
@property (nonatomic, strong) NSMutableArray *communityArticles;
@property (nonatomic, strong) NSMutableArray *featuresArticles;
@property (nonatomic, strong) NSMutableArray *opinionsArticles;
@property (nonatomic, strong) NSMutableArray *sportArticles;
@property (nonatomic, strong) NSMutableArray *unsortedArticles;

+ (DataModel *)sharedModel;
- (void)fetchArticlesWithCompletionBlock:(FetchArticlesCompletionBlock)completion;

- (void)searchArticlesForTerm:(NSString *)searchTerm withCompletionBlock:(FetchArticlesCompletionBlock)completionBlock;

- (void) fetchArticlesForCategory:(NSString *) category withCompletionBlock:(FetchArticlesCompletionBlock)completion;

- (NSMutableArray *)categoryArrayForCategoryName:(NSString *)categoryName;
- (void)saveArticle:(Article *)article;
- (void)deleteArticle:(Article *)article;
- (NSMutableArray *)savedArticles;
- (void)markArticleAsRead:(Article *)article; 
- (NSMutableSet *)readArticles;


@end
