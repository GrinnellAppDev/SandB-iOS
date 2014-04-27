//
//  NewArticlesListTableViewController.m
//  SandB-iOS
//
//  Created by Lea Marolt on 4/6/14.
//  Copyright (c) 2014 Grinnell AppDev. All rights reserved.
//

#import "NewArticlesListTableViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "NewArticleCell.h"
#import "DataModel.h"
#import "NewArticlePageViewHolderController.h"
#import "NewsCategories.h"
#import "Cache.h"

const int kLoadingCellTag = 888; // Tag for the loadingCell. This cell is drawn automatically.

@interface NewArticlesListTableViewController ()
@property (nonatomic) NSInteger articleIndex;
@property (nonatomic, strong) NSArray *categoryColors;
@property (nonatomic, strong) NSString *newsCategory;
@property (nonatomic, strong) NSMutableArray *allArticlesArray;

@property (nonatomic, assign) BOOL isFetchingArticles;

@end

@implementation NewArticlesListTableViewController
{
    int _currentPage;
    int _totalPages;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureECSlidingController];
    self.allArticlesArray = [NSMutableArray new];
//    self.allArticlesArray = [self getArrayForView];
    
    // On the first time load, check the cache contents and load those in first if there are any.
    // Fetch for a new articles right a fter.
    
    self.newsCategory = @"News";
    if (self.recievedCategory) {
        self.newsCategory = self.recievedCategory;
        NSLog(@"Received Category: %@", self.recievedCategory);
    }
    
    
    if ([self.newsCategory isEqualToString:@"News"]) {
        
        //Check the cache content.
        NSMutableArray *news =  [[Cache sharedCacheModel] loadArchivedObjectWithFileName:@"News"];
        if (news) {
            NSLog(@"loading articles from cache");
            
            self.allArticlesArray = news;
        }
        [self fetchArticles];
    }
    else if ([self.newsCategory isEqualToString:@"Favorites"]) {
        // Do nothing on favorites.
        self.allArticlesArray =  [[DataModel sharedModel] savedArticles];
    }
    else {
        
        //Check cache content of category.
        NSMutableArray *categoryCache = [[Cache sharedCacheModel] loadArchivedObjectWithFileName:self.recievedCategory];
        if (categoryCache) {
            NSLog(@"loading from category cache");
            self.allArticlesArray = categoryCache;
        }
        [self fetchCategoryArticles];
    }
    
    [self.tableView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    

}

/* Fetch all the news articles. 
    Cache them right after you fetch them 
 */
- (void)fetchArticles {
    
    [[DataModel sharedModel] fetchArticlesWithCompletionBlock:^(NSMutableArray *articles, NSMutableArray *newArticles, int totalPages, int currentPage, NSError *error) {
        if (!error) {
            _currentPage = currentPage;
            _totalPages = totalPages;
            self.allArticlesArray = articles;
            [self.tableView reloadData];
            [[Cache sharedCacheModel] archiveObject:articles toFileName:@"News"];
        }
        else {
            NSLog(@"I am sad!: %@", [error description]);
        }
        self.isFetchingArticles = NO;
    }];
}

- (void)fetchCategoryArticles {
    
    [[DataModel sharedModel] fetchArticlesForCategory:self.recievedCategory withCompletionBlock:
     ^(NSMutableArray *articles, NSMutableArray *newArticles, int totalPages, int currentPage, NSError *error) {
         if (!error) {
             _currentPage = currentPage;
             _totalPages = totalPages;
             self.allArticlesArray = articles;
             [self.tableView reloadData];
             [[Cache sharedCacheModel] archiveObject:articles toFileName:self.recievedCategory];
         }
         else {
             NSLog(@"I am sad! :%@", [error description]);
         }
         self.isFetchingArticles = NO;
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // If there are more articles that can be displayed.
    if (_currentPage < _totalPages) {
        return [[self getArrayForView] count] + 1; //+1 for the extra loading cell since there are more pages.
    } else {
        return [self.allArticlesArray  count];
    }
}


- (UITableViewCell *)articleCellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"NewArticleCell";
    
    NewArticleCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //Customize Cell
    cell.articleTitle.text = [[self.allArticlesArray  objectAtIndex:indexPath.row] title];
    
    if ([[self.allArticlesArray objectAtIndex:indexPath.row] author]) {
    cell.articleDetails.text = [NSString stringWithFormat:@"%@ | %@",[[self.allArticlesArray objectAtIndex:indexPath.row] date], [[self.allArticlesArray objectAtIndex:indexPath.row] author]];
    }
    else {
    cell.articleDetails.text = [NSString stringWithFormat:@"%@ | S&B",[[self.allArticlesArray objectAtIndex:indexPath.row] date]]; 
    }
    
    // if article has been clicked on, aka red, color it with the category color to mark it as read
    if ([[self.allArticlesArray  objectAtIndex:indexPath.row] read]) {
        cell.backgroundColor = [[[[NewsCategories sharedCategories] categoriesByName] objectForKey:[[self.allArticlesArray  objectAtIndex:indexPath.row] category]]  highlightedColor];
        cell.articleTitle.textColor = [UIColor grayColor];
        [cell.articleTitle setFont:[UIFont fontWithName:@"ProximaNova-Light" size:18]];
        cell.articleDetails.textColor = [UIColor grayColor];
        cell.categoryIdentifier.backgroundColor = [[[[NewsCategories sharedCategories] categoriesByName] objectForKey:[[self.allArticlesArray objectAtIndex:indexPath.row] category]] readBarColor];
    }
    else {
        cell.backgroundColor = [UIColor whiteColor];
        cell.articleTitle.textColor = [UIColor blackColor];
        [cell.articleTitle setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:18]];
        cell.articleDetails.textColor = [UIColor blackColor];
        cell.categoryIdentifier.backgroundColor = [[[[NewsCategories sharedCategories] categoriesByName] objectForKey:[[self.allArticlesArray objectAtIndex:indexPath.row] category]] color];
    }
    
    [cell.articleDetails setFont:[UIFont fontWithName:@"ProximaNova-Light" size:12]];
    
    // make sure the selected color stays
    
    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row <  [self.allArticlesArray   count]) {
        return [self articleCellForIndexPath:indexPath];
    } else {
        return [self loadingCell];
    }
}

- (UITableViewCell *)loadingCell
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = cell.center;
    [cell addSubview:activityIndicator];
    [activityIndicator startAnimating];
    cell.tag = kLoadingCellTag;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell.tag == kLoadingCellTag) {
        
        //Know which one to do depending on view options.
        [self fetchArticlesForView];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewArticleCell *cell = (NewArticleCell *) [tableView cellForRowAtIndexPath:indexPath];
    
    cell.backgroundColor = [[[[NewsCategories sharedCategories] categoriesByName] objectForKey:[[self.allArticlesArray objectAtIndex:indexPath.row] category]] highlightedColor];
    
    [[self.allArticlesArray  objectAtIndex:indexPath.row] setRead:YES];
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
        if ([segue.destinationViewController isKindOfClass:[NewArticlePageViewHolderController class]]) {
            NewArticlePageViewHolderController *napvhc = segue.destinationViewController;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            NSUInteger currentArticleIndex = indexPath.row;
            
            napvhc.articleIndex = currentArticleIndex;
            napvhc.recievedCategoryString = self.newsCategory;
            
            //Test this out.
            napvhc.pageArticles = self.allArticlesArray;
        }
    }
}

#pragma mark - ECSliding methods

- (void)configureECSlidingController {
    // setup swipe and button gestures for the sliding view controller
    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
    self.slidingViewController.customAnchoredGestures = @[];
    //    [[self.navigationController.viewControllers.firstObject view] addGestureRecognizer:self.slidingViewController.panGesture];
    
    // TO DO: Swipe to the right to reveal menu
}

// gets the correct array to display, i.e - whatever the user clicked on - news, favorites, w/e
- (NSMutableArray *)getArrayForView {
    
    if ([self.newsCategory isEqualToString:@"News"]) {
        return [[DataModel sharedModel] articles];
    }
    else if ([self.newsCategory isEqualToString:@"Favorites"]) {
        
        return [[DataModel sharedModel] savedArticles];
    }
    else {
        return [[DataModel sharedModel] categoryArrayForCategoryName:self.newsCategory];
    }
}

- (void)fetchArticlesForView {
    if (!self.isFetchingArticles) {
        self.isFetchingArticles = YES;
        
        if ([self.newsCategory isEqualToString:@"News"]) {
            [self fetchArticles];
        }
        else {
            [self fetchCategoryArticles];
        }
    }
}

-(IBAction)refreshButtonPressed:(id)sender {
    [self fetchArticlesForView];
}

@end
