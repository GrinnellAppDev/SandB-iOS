
#import "Article.h"
#import "ArticleCell.h"
#import "ArticlePageViewHolderController.h"
#import "ArticlesListTableViewController.h"
#import "Cache.h"
#import "DataModel.h"
#import "NewsCategories.h"
#import "UIViewController+ECSlidingViewController.h"

const int kLoadingCellTag = 888; // Tag for the loadingCell. This cell is drawn automatically.

@interface ArticlesListTableViewController ()

@property (nonatomic) NSInteger articleIndex;
@property (nonatomic, strong) NSArray *categoryColors;
@property (nonatomic, strong) NSString *newsCategory;
@property (nonatomic, strong) NSMutableArray *allArticlesArray;

@property (nonatomic, assign) BOOL isFetchingArticles;

@end

@implementation ArticlesListTableViewController {
    int _currentPage;
    int _totalPages;
}


#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self configureECSlidingController];
    self.allArticlesArray = [NSMutableArray new];
    
    self.newsCategory = @"News";
    if (self.recievedCategory) {
        self.newsCategory = self.recievedCategory;
    }
    
    // On the first time load, check the cache contents and load those in first if there are any.
    // Fetch for a new articles right after.
    
    if ([self.newsCategory isEqualToString:@"Favorites"]) {
        // Do nothing on favorites.
        self.allArticlesArray =  [[DataModel sharedModel] savedArticles];
        [self.tableView reloadData];
        
    } else {
        NSMutableArray *cachedArticles =  [[Cache sharedCacheModel]
                                              loadArchivedObjectWithFileName:self.newsCategory];
        
        if (cachedArticles) {
            self.allArticlesArray = cachedArticles;
        }
        
        [self fetchArticles];
        [self.refreshControl beginRefreshing];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    if ([self.newsCategory isEqualToString:@"Favorites"]) {
        self.allArticlesArray = [[DataModel sharedModel] savedArticles];
    }
    
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // If there are more articles that can be displayed.
    if (_currentPage < _totalPages) {
        return [[self getArrayForView] count] + 1; //+1 for the extra loading cell
    } else {
        return [self.allArticlesArray  count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row <  [self.allArticlesArray count]) {
        return [self articleCellForIndexPath:indexPath];
    } else {
        return [self loadingCell];
    }
}

- (void)tableView:(UITableView *)tableView
      willDisplayCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (cell.tag == kLoadingCellTag) {
        //Know which one to do depending on view options.
        [self fetchArticles];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleCell *cell = (ArticleCell *) [tableView cellForRowAtIndexPath:indexPath];
    Article *article = [self.allArticlesArray objectAtIndex:indexPath.row];
    NewsCategory *category = [[[NewsCategories sharedCategories] categoriesByName]
                                 objectForKey:article.category];
    
    cell.backgroundColor = category.highlightedColor;
    
    [[DataModel sharedModel] markArticleAsRead:article];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)setCellColor:(UIColor *)color ForCell:(UITableViewCell *)cell {
    cell.contentView.backgroundColor = color;
    cell.backgroundColor = color;
}


#pragma mark - Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        if ([segue.destinationViewController
                isKindOfClass:[ArticlePageViewHolderController class]]) {
            
            ArticlePageViewHolderController *apvhc = segue.destinationViewController;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            NSUInteger selectedArticleIndex = indexPath.row;
            
            apvhc.articleIndex = selectedArticleIndex;
            apvhc.recievedCategoryString = self.newsCategory;
            apvhc.sentArticle = [self.allArticlesArray objectAtIndex:selectedArticleIndex];
            
            //Test this out.
            apvhc.pageArticles = self.allArticlesArray;
        }
    }
}


#pragma mark - IBActions

- (IBAction)refresh:(UIRefreshControl *)sender {
    [self fetchArticles];
}


#pragma mark - ECSliding methods

- (void)configureECSlidingController {
    // setup swipe and button gestures for the sliding view controller
    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
    self.slidingViewController.customAnchoredGestures = @[];
    
    // TO DO: Swipe to the right to reveal menu
}


#pragma mark - Helper methods

/* Fetch all the news articles.
 * Cache them right after you fetch them
 */
- (void)fetchArticles {
    NSString *categoryName = self.newsCategory; // Capture category name for async block
    
    static void (^newArticlesHandler)(NSMutableArray *, NSMutableArray *, int, int, NSError*);
    newArticlesHandler = ^(NSMutableArray *articles,
                           NSMutableArray *newArticles,
                           int totalPages,
                           int currentPage,
                           NSError *error) {
        if (!error) {
            _currentPage = currentPage;
            _totalPages = totalPages;
            
            self.allArticlesArray = articles;
            [self.tableView reloadData];
            [[Cache sharedCacheModel] archiveObject:articles toFileName:categoryName];
        } else {
            NSLog(@"I am sad!: %@", error.description);
        }
        
        self.isFetchingArticles = NO;
        [self.refreshControl endRefreshing];
    };
    
    if (self.isFetchingArticles) {
        return;
    }
    
    self.isFetchingArticles = YES;
    
    if ([categoryName isEqualToString:@"News"]) {
        [[DataModel sharedModel] fetchArticlesWithCompletionBlock:newArticlesHandler];
    } else {
        [[DataModel sharedModel] fetchArticlesForCategory:categoryName
                                      withCompletionBlock:newArticlesHandler];
    }
}

// gets the correct array to display, i.e - whatever the user clicked on - news, favorites, w/e
- (NSMutableArray *)getArrayForView {
    
    if ([self.newsCategory isEqualToString:@"News"]) {
        return [[DataModel sharedModel] articles];
    } else if ([self.newsCategory isEqualToString:@"Favorites"]) {
        return [[DataModel sharedModel] savedArticles];
    } else {
        return [[DataModel sharedModel] categoryArrayForCategoryName:self.newsCategory];
    }
}

- (UITableViewCell *)articleCellForIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ArticleCell";
    
    ArticleCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Article *article = [self.allArticlesArray objectAtIndex:indexPath.row];
    NewsCategory *category = [[[NewsCategories sharedCategories] categoriesByName]
                              objectForKey:article.category];
    
    //Customize Cell
    cell.articleTitle.text = article.title;
    
    if (article.author) {
        cell.articleDetails.text = [NSString
                                    stringWithFormat:@"%@ | %@", article.date, article.author];
    } else {
        cell.articleDetails.text = [NSString stringWithFormat:@"%@ | S&B", article.date];
    }
    
    // if article has been clicked on, aka read, color it with the category color to mark it as read
    if ([[[DataModel sharedModel] readArticles] containsObject:article] &&
        ![self.newsCategory isEqualToString:@"Favorites"]) {
        
        [cell.articleTitle setFont:[UIFont fontWithName:@"ProximaNova-Light" size:18]];
        
        cell.articleTitle.textColor = [UIColor grayColor];
        cell.articleDetails.textColor = [UIColor grayColor];
        
        cell.backgroundColor = category.highlightedColor;
        cell.categoryIdentifier.backgroundColor = category.readBarColor;
        
    } else {
        [cell.articleTitle setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:18]];
        
        cell.articleTitle.textColor = [UIColor blackColor];
        cell.articleDetails.textColor = [UIColor blackColor];
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.categoryIdentifier.backgroundColor = category.color;
    }
    
    [cell.articleDetails setFont:[UIFont fontWithName:@"ProximaNova-Light" size:12]];
    
    return cell;
}

- (UITableViewCell *)loadingCell {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:nil];
    cell.tag = kLoadingCellTag;
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = cell.center;
    
    [cell addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    
    return cell;
}

@end
