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

const int kLoadingCellTag = 888; // Tag for the loadingCell. This cell is drawn automatically.

@interface NewArticlesListTableViewController ()
@property (nonatomic) NSInteger articleIndex;
@property (nonatomic, strong) NSArray *categoryColors;
@property (nonatomic, strong) NSString *newsCategory;

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
    
    self.newsCategory = @"News";
    if (self.recievedCategory) {
        self.newsCategory = self.recievedCategory;
    }
    
    [self ecslidingOptions];
    if ([self.newsCategory isEqualToString:@"News"]) {
        NSLog(@"am i getting here?!");
        [self fetchArticles];
    }
    else {
        [self fetchCategoryArticles];
        NSLog(@"AM I GETTING CATEGORY DATA?!?!?!");
    }
}

- (void) fetchArticles {
    
    [[DataModel sharedModel] fetchArticlesWithCompletionBlock:^(NSMutableArray *articles, NSMutableArray *newArticles, int totalPages, int currentPage, NSError *error) {
        if (!error) {
            _currentPage = currentPage;
            _totalPages = totalPages;
            [self.tableView reloadData];
        }
        else {
            NSLog(@"I am sad!");
        }
        self.isFetchingArticles = NO;
    }];
    
}

- (void) fetchCategoryArticles {
    
    [[DataModel sharedModel] fetchArticlesForCategory:self.recievedCategory withCompletionBlock:
     ^(NSMutableArray *articles, NSMutableArray *newArticles, int totalPages, int currentPage, NSError *error) {
         if (!error) {
             _currentPage = currentPage;
             _totalPages = totalPages;
             [self.tableView reloadData];
         }
         else {
             NSLog(@"I am sad!");
         }
         self.isFetchingArticles = NO; 
     }];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    [self.tableView reloadData];
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
        return [[self getArrayForView] count];
    }
}


- (UITableViewCell *)articleCellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"NewArticleCell";
    
    NewArticleCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //Customize Cell
    cell.articleTitle.text = [[[self getArrayForView] objectAtIndex:indexPath.row] title];
    
    cell.articleDetails.text = [NSString stringWithFormat:@"%@ | %@",[[[self getArrayForView]objectAtIndex:indexPath.row] date], [[[self getArrayForView]objectAtIndex:indexPath.row] author]];
    cell.categoryIdentifier.backgroundColor = [[[[NewsCategories sharedCategories] categoriesByName] objectForKey:[[[self getArrayForView]objectAtIndex:indexPath.row] category]] color];
    
    // if article has been clicked on, aka red, color it with the category color to mark it as read
    if ([[[self getArrayForView] objectAtIndex:indexPath.row] read]) {
        cell.backgroundColor = [[[[NewsCategories sharedCategories] categoriesByName] objectForKey:[[[self getArrayForView] objectAtIndex:indexPath.row] category]]  highlightedColor];
    }
    else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    // make sure the selected color stays
    
    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row <  [[self getArrayForView]  count]) {
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
    
    cell.backgroundColor = [[[[NewsCategories sharedCategories] categoriesByName] objectForKey:[[[self getArrayForView]objectAtIndex:indexPath.row] category]] highlightedColor];
    
    [[[self getArrayForView] objectAtIndex:indexPath.row] setRead:YES];
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
        }
    }
}

#pragma mark - ECSliding methods

-(void)ecslidingOptions {
    // setup swipe and button gestures for the sliding view controller
    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
    self.slidingViewController.customAnchoredGestures = @[];
    //    [[self.navigationController.viewControllers.firstObject view] addGestureRecognizer:self.slidingViewController.panGesture];
    
    // TO DO: Swipe to the right to reveal menu
}

- (NSMutableArray *)getArrayForView {
    if ([self.newsCategory isEqualToString:@"News"]) {
        return [[DataModel sharedModel] articles];
    }
    else {
        return [[DataModel sharedModel] categoryArticles];
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



@end
