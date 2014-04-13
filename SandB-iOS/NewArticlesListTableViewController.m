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

@interface NewArticlesListTableViewController ()
@property (nonatomic) NSInteger articleIndex;
@property (nonatomic, strong) NSArray *categoryColors;
@property (nonatomic, strong) NSString *newsCategory;

@end

@implementation NewArticlesListTableViewController

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
            [self.tableView reloadData];
        }
        else {
            NSLog(@"I am sad!");
        }
    }];

}

- (void) fetchCategoryArticles {
    
    [[DataModel sharedModel] fetchArticlesForCategory:self.recievedCategory withCompletionBlock:
     ^(NSMutableArray *articles, NSMutableArray *newArticles, int totalPages, int currentPage, NSError *error) {
         if (!error) {
             [self.tableView reloadData];
         }
         else {
             NSLog(@"I am sad!");
         }
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
    // Return the number of rows in the section.
    return [[self viewOptions] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewArticleCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
        cell.articleTitle.text = [[[self viewOptions] objectAtIndex:indexPath.row] title];
        cell.articleDetails.text = [NSString stringWithFormat:@"%@ | %@",[[[self viewOptions]objectAtIndex:indexPath.row] date], [[[self viewOptions]objectAtIndex:indexPath.row] author]];
        cell.categoryIdentifier.backgroundColor = [[[[NewsCategories sharedCategories] categoriesByName] objectForKey:[[[self viewOptions]objectAtIndex:indexPath.row] category]] color];
    
        // if article has been clicked on, aka red, color it with the category color to mark it as read
        if ([[[self viewOptions] objectAtIndex:indexPath.row] read]) {
            cell.backgroundColor = [[[[NewsCategories sharedCategories] categoriesByName] objectForKey:[[[self viewOptions] objectAtIndex:indexPath.row] category]]  highlightedColor];
        }
        else {
            cell.backgroundColor = [UIColor whiteColor];
        }
    
    // make sure the selected color stays
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewArticleCell *cell = (NewArticleCell *) [tableView cellForRowAtIndexPath:indexPath];
    
    cell.backgroundColor = [[[[NewsCategories sharedCategories] categoriesByName] objectForKey:[[[self viewOptions]objectAtIndex:indexPath.row] category]] highlightedColor];
    
    [[[self viewOptions] objectAtIndex:indexPath.row] setRead:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)setCellColor:(UIColor *)color ForCell:(UITableViewCell *)cell {
    cell.contentView.backgroundColor = color;
    cell.backgroundColor = color;
}

// SEGUE METHODS

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        if ([segue.destinationViewController isKindOfClass:[NewArticlePageViewHolderController class]]) {
            NewArticlePageViewHolderController *napvhc = segue.destinationViewController;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            NSUInteger currentArticleIndex = indexPath.row;
            
            napvhc.articleIndex = currentArticleIndex;
            napvhc.letsSeeIfYouWork = self.newsCategory;
        }
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - ECSliding methods

-(void)ecslidingOptions {
    // setup swipe and button gestures for the sliding view controller
    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
    self.slidingViewController.customAnchoredGestures = @[];
//    [[self.navigationController.viewControllers.firstObject view] addGestureRecognizer:self.slidingViewController.panGesture];
    
    // TO DO: Swipe to the right to reveal menu
}

- (NSMutableArray *) viewOptions {
    if ([self.newsCategory isEqualToString:@"News"]) {
        return [[DataModel sharedModel] articles];
    }
    else {
        return [[DataModel sharedModel] categoryArticles];
    }
}

@end
