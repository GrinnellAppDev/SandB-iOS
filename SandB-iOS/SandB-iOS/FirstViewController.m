//
//  FirstViewController.m
//  SandB-iOS
//
//  Created by Lea Marolt on 1/25/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import "FirstViewController.h"
#import "ArticleViewController.h"
#import "Reachability.h"
#import "Article.h"

@interface FirstViewController ()

@end

@implementation FirstViewController{
    NSString *alert;
}

@synthesize cellIdentifier;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Rename the back button on the child views
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    
    self.cellIdentifier = @"NewsCell";
    self.title = @"Scarlet and Black";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
   // [self loadArticles];
    
    //Get the XML data
    NSData *xmlData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:@"http://www.thesandb.com/feed"]];
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
            articleBody = [articleBody stringByReplacingOccurrencesOfString:@"<p>" withString:@"\n"];
            articleBody = [articleBody stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
            articleBody = [articleBody stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
            articleBody = [articleBody stringByReplacingOccurrencesOfString:@"&#8230" withString:@"... "];
            articleBody = [articleBody stringByReplacingOccurrencesOfString:@"&#8217;" withString:@"'"];
            articleTitle = [articleTitle stringByReplacingOccurrencesOfString:@"&#8230" withString:@"... "];
            articleTitle = [articleTitle stringByReplacingOccurrencesOfString:@"&#8217;" withString:@"'"];
            
            art.title = articleTitle;
            art.article = articleBody;
            [articleArray addObject:art];
            elem_ARTICLE = [TBXML nextSiblingNamed:@"item" searchFromElement:elem_ARTICLE];
            
        }
    }
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
/*
- (void)loadArticles {
    NSMutableString *url = [NSMutableString stringWithFormat:@"http://www.thesandb.com/feed"];
    
    //You should test for a network connection before here.
    if ([self networkCheck]) {
        //There's a network connection. Before Pulling in any real data. Let's check if there actually is any data available.
        
       // FOR PARSING: NSError *error;
        NSData *availableData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        @try {
           // TODO - Parse the data
            
            
        }
        @catch (NSException *e) {
            alert = @"server";
            UIAlertView *network = [[UIAlertView alloc]
                                    initWithTitle:@"Network Error"
                                    message:@"The connection to the server failed. Please check back later. Sorry for the inconvenience."
                                    delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil
                                    ];
            [network show];
            return;
        }
        NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
        [parser parse];
        
        NSLog(@"%@", parser);
    }
}*/

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
