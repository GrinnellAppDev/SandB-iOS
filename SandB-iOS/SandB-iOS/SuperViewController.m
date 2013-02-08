//
//  SuperViewController.m
//  SandB-iOS
//
//  Created by Colin Tremblay on 2/8/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import "SuperViewController.h"
#import "ArticleViewController.h"
#import "Reachability.h"
#import "Article.h"

@interface SuperViewController ()

@end

@implementation SuperViewController{
    NSString *alert;
}

@synthesize cellIdentifier;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // custom??
    }
    return self;
}


- (void)loadArticles:(NSString *)url{
    //Get the XML data
    NSData *xmlData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];
    tbxml = [[TBXML alloc]initWithXMLData:xmlData];
    articleArray = [[NSMutableArray alloc] init];
    // Obtain root element
    TBXMLElement * root = tbxml.rootXMLElement;
    if (root)
    {
        TBXMLElement * elem_NEWroot = [TBXML childElementNamed:@"channel" parentElement:root];
        TBXMLElement * elem_ARTICLE = [TBXML childElementNamed:@"item" parentElement:elem_NEWroot];
        while (elem_ARTICLE !=nil)
        {
            TBXMLElement * elem_TITLE = [TBXML childElementNamed:@"title" parentElement:elem_ARTICLE];
            TBXMLElement * elem_TEXT = [TBXML childElementNamed:@"content:encoded" parentElement:elem_ARTICLE];
            Article * art = [[Article alloc] init];
            NSString *articleTitle = [TBXML textForElement:elem_TITLE];
            NSString *articleBody = [TBXML textForElement:elem_TEXT];
            
            // TODO - Refactor this!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            articleBody = [articleBody stringByReplacingOccurrencesOfString:@"<p>" withString:@"\n"];
            articleBody = [articleBody stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
            articleBody = [articleBody stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
            articleBody = [articleBody stringByReplacingOccurrencesOfString:@"<em>" withString:@""];
            articleBody = [articleBody stringByReplacingOccurrencesOfString:@"&#8230" withString:@"... "];
            articleBody = [articleBody stringByReplacingOccurrencesOfString:@"&#8220" withString:@"\""];
            articleBody = [articleBody stringByReplacingOccurrencesOfString:@"&#8221" withString:@"\""];
            articleBody = [articleBody stringByReplacingOccurrencesOfString:@"&#8217;" withString:@"'"];
            articleBody = [articleBody stringByReplacingOccurrencesOfString:@"&#8211;" withString:@"-"];
            articleBody = [articleBody stringByReplacingOccurrencesOfString:@"&#038;" withString:@"&"];
            articleBody = [articleBody stringByReplacingOccurrencesOfString:@"&#215;" withString:@"x"];
            articleBody = [articleBody stringByReplacingOccurrencesOfString:@"&#039;" withString:@"'"];
            articleBody = [articleBody stringByReplacingOccurrencesOfString:@"&#60;" withString:@"<"];
            articleBody = [articleBody stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
            articleTitle = [articleTitle stringByReplacingOccurrencesOfString:@"&#8230" withString:@"... "];
            articleTitle = [articleTitle stringByReplacingOccurrencesOfString:@"&#8217;" withString:@"'"];
            articleTitle = [articleTitle stringByReplacingOccurrencesOfString:@"&#038;" withString:@"&"];
            articleTitle = [articleTitle stringByReplacingOccurrencesOfString:@"&#039;" withString:@"'"];
            articleTitle = [articleTitle stringByReplacingOccurrencesOfString:@"&#8211;" withString:@"-"];
            articleTitle = [articleTitle stringByReplacingOccurrencesOfString:@"&#215;" withString:@"x"];
            articleTitle = [articleTitle stringByReplacingOccurrencesOfString:@"&#8220" withString:@"\""];
            articleTitle = [articleTitle stringByReplacingOccurrencesOfString:@"&#8221" withString:@"\""];
            
            art.title = articleTitle;
            art.article = articleBody;
            [articleArray addObject:art];
            elem_ARTICLE = [TBXML nextSiblingNamed:@"item" searchFromElement:elem_ARTICLE];
            
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Rename the back button on the child views
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    self.cellIdentifier = @"NewsCell";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
   // self.title = @"Scarlet and Black";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Method to determine the availability of network Connections using the Reachability Class
- (BOOL)networkCheck {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    return (!(networkStatus == NotReachable));
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section {
    return articleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Register the NIB cell object
    [tableView registerNib:[UINib nibWithNibName:@"NewsCell" bundle:nil] forCellReuseIdentifier:self.cellIdentifier];
    
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
	}
    UILabel *newsTitle = (UILabel *)[cell viewWithTag:1001];
    UIImageView *newsImage = (UIImageView *)[cell viewWithTag:1002];
    UILabel *newsArticle = (UILabel *)[cell viewWithTag:1003];
    Article *currentArticle = [[Article alloc] init];
    currentArticle = [articleArray objectAtIndex:indexPath.row];
    
    newsTitle.text = currentArticle.title;
    newsArticle.text = currentArticle.article;
    [newsImage setImage:[UIImage imageNamed:@"first.png"]];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 122;
    //    return [indexPath row] * 20;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // TODO - Set this based on URL
    return @"Newest Stories";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleViewController *articlePage = [[ArticleViewController alloc] initWithNibName:@"ArticleViewController" bundle:nil];
    articlePage.article = [[Article alloc] init];
    articlePage.article = [articleArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:articlePage animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark UIAlertViewDelegate Methods
// Called when an alert button is tapped.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    return;
}

@end


