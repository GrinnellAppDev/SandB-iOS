//
//  ArticlesListViewController.m
//  SandB-iOS
//
//  Created by Maijid Moujaled on 12/23/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import "ArticlesListViewController.h"
#import "GlassViewController.h"
#import "Article.h"
#import "AFNetworking.h"
#import "SandBClient.h"
#import "DataModel.h"
#import "ArticleCell.h"

#import <Crashlytics/Crashlytics.h>

const int kLoadingCellTag = 888;

@interface ArticlesListViewController () <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *theTableView;
//@property (nonatomic, strong) NSMutableArray *articles;
@property (nonatomic, assign) int  currentPage;
@property (nonatomic, assign) int totalPages;

@end

@implementation ArticlesListViewController




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _currentPage = 1;
    
    [self fetchArticles];
    
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;

    [self.theTableView setContentOffset:CGPointMake(0, 44)];

   // self.articles = [NSMutableArray new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.theTableView reloadData];
    
}


#pragma mark - SearchDisplayControllerDelegate

- (void)searchDisplayControllerWillBeginSearch: (UISearchDisplayController *)controller
{
    self.searchDisplayController.searchBar.showsCancelButton = YES;
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    
    self.searchDisplayController.searchBar.showsCancelButton =NO;
    
}
- (IBAction)triggerSearch:(id)sender {
    NSLog(@"tiggering search");
    NSLog(@"searchBar: %@",self.searchBar);
    
    [self.searchBar becomeFirstResponder];
    
//    [self.searchBar becomeFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self.view endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    NSLog(@"Search for %@", searchBar.text);
    
    [[DataModel sharedModel] searchArticlesForTerm:searchBar.text withCompletionBlock:^(NSMutableArray *articles, NSMutableArray *newArticles, int totalPages, int currentPage, NSError *error) {
        if (!error) {
            [self.theTableView reloadData];
        }
    }];
}

- (void)fetchArticles
{

    
    [[DataModel sharedModel] fetchArticlesWithCompletionBlock:^(NSMutableArray *articles, NSMutableArray *newArticles, int totalPages, int currentPage, NSError *error) {
        if (!error) {
            _totalPages = totalPages;
            _currentPage = currentPage;
            [self.theTableView reloadData];
        }
    }];
    
    
    /*
    [[SandBClient sharedClient] GET:@"get_recent_posts/"
                         parameters:@{@"count": @(10),
                                      @"page": @(_currentPage)
                                      }
                            success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                                
                                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                
                                if (httpResponse.statusCode == 200) {
                                    _totalPages = [responseObject[@"pages"] intValue];
                                    NSArray *articleArray = responseObject[@"posts"];
                                    [articleArray enumerateObjectsUsingBlock:^(NSDictionary *articleDictionary, NSUInteger idx, BOOL *stop) {
                                        
                                        Article *article = [[Article alloc] initWithArticleDictionary:articleDictionary];
                                        [[[DataModel sharedModel] articles] addObject:article];
                                        //                                        [self.articles addObject:article];
                                    }];
                                    [self.theTableView reloadData];
                                    //NSLog(@"articles: %@", self.articles);
                                }
                                
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                //Failure callback gets called when the request itself fails.
                                //ie sucess could mean you could "successfully" get a 500.
                                NSLog(@"Failure... %@", error);
                            }];
     */ 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_currentPage < _totalPages) {
        return [[[DataModel sharedModel] articles] count] + 1;
    } else {
        return [[[DataModel sharedModel] articles] count];
    }
//    return self.articles.count;
}

- (UITableViewCell *)articleCellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ArticleCell";
    
    ArticleCell *cell = [self.theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //Customize Cell
    Article *a = [[[DataModel sharedModel] articles] objectAtIndex:indexPath.row];
    //  self.articles[indexPath.row]
    
    [cell.titleLabel setFont:[UIFont fontWithName:@"Raleway-Regular" size:18.f]];
    
    [cell.dateAndAuthorLabel setFont:[UIFont fontWithName:@"Raleway-Thin" size:12.f]];
    
    cell.titleLabel.text = a.title;
    cell.dateAndAuthorLabel.text = [NSString stringWithFormat:@"Mar 13 | %@", a.author];

    return cell;

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < [[[DataModel sharedModel] articles] count]) {
        return [self articleCellForIndexPath:indexPath];
    } else {
        return [self loadingCell];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showGlassViews"]) {
        GlassViewController *glvc = segue.destinationViewController;
        glvc.articles = [[DataModel sharedModel] articles];
        
        //Push to the article that was tapped. 
        NSIndexPath *indexPath = [self.theTableView indexPathForCell:sender];
        glvc.page = indexPath.row;
        
    }
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell.tag == kLoadingCellTag) {
        [self fetchArticles];
    }
}

@end
