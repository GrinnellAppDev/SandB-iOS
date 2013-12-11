//
//  SuperViewController.m
//  SandB-iOS
//
//  Created by Colin Tremblay on 2/8/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import "SuperViewController.h"
#import "ArticleViewController.h"
#import "Article.h"
#import "NSString_stripHtml.h"
#import <Reachability.h>
#import <MBProgressHUD.h>

@interface SuperViewController ()

@end

@implementation SuperViewController{
    NSString *alert;
}

@synthesize cellIdentifier, theTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
        ;//customize here
    return self;
}

- (void)loadArticles:(NSString *)url{
    NSString *originalTempPath = NSTemporaryDirectory();
    NSString *urlForOriginalPath = [url stringByReplacingOccurrencesOfString:@"http://www.thesandb.com/" withString:@""];
    urlForOriginalPath = [urlForOriginalPath stringByReplacingOccurrencesOfString:@"/" withString:@""];

    NSString *originalFeed = [NSString stringWithFormat:@"%@.plist", urlForOriginalPath];
    NSString *originalPath = [originalTempPath stringByAppendingPathComponent:originalFeed];
    
   // NSLog(@"About to test for cached article file called: %@", originalPath);
    if ([[NSFileManager defaultManager] fileExistsAtPath:originalPath]) {
        articleArray = [NSKeyedUnarchiver unarchiveObjectWithFile:originalPath];
        [theTableView reloadData];
        //NSLog(@"USING CACHED VERSION");
    }
    else {
      //  NSLog(@"No cache... showing HUD");
        // Set up HUD
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading";
    }
    
    if ([self networkCheck]) {
        // Dispatch our thread for getting data
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Try to get and parse the data
            @try {
                // Get the XML data
                NSData *xmlData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];
                NSError *err;
                tbxml = [[TBXML alloc] initWithXMLData:xmlData error:&err];
                
                // Throw exception if any error occured
                if (err != NULL){
                    NSString *exceptionString = [NSString stringWithFormat:@"%@", err];
                    @throw [NSException exceptionWithName:@"TBXMLParseError" reason:exceptionString userInfo:nil];
                }
                
                // Obtain root element
                TBXMLElement * root = tbxml.rootXMLElement;
                if (root) {
                    // Get to the articles and iterate through them
                    TBXMLElement *elem_NewRoot = [TBXML childElementNamed:@"channel"
                                                            parentElement:root];
                    
                    TBXMLElement *elem_Date = [TBXML childElementNamed:@"lastBuildDate"
                                                         parentElement:elem_NewRoot];
                    NSString *date = [TBXML textForElement:elem_Date];
                    
                    NSString *path = [originalPath stringByReplacingOccurrencesOfString:@"feed.plist" withString:@"feed-date.plist"];

                    //NSLog(@"About to test for date file called: %@", path);
                    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                        NSString *dateStr = [[NSString alloc] initWithContentsOfFile:path encoding:NSStringEncodingConversionAllowLossy error:&err];
                        // Throw exception if any error occured
                        if (err != NULL){
                            NSString *exceptionString = [NSString stringWithFormat:@"%@", err];
                            @throw [NSException exceptionWithName:@"DateFileReadError" reason:exceptionString userInfo:nil];
                        }
                        
                        if (![date isEqualToString:dateStr])
                            [self parseFeed:elem_NewRoot withPath:originalPath andDate:date];
                      // else NSLog(@"DATES EQUAL - USING CACHED VERSION");
                    }
                    else {
                        [self parseFeed:elem_NewRoot withPath:originalPath andDate:date];
                    }
                }
            }
            @catch (NSException *exception) {
                // An error occured - Show Alert
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self performSelectorOnMainThread:@selector(showErrorAlert)
                                       withObject:nil
                                    waitUntilDone:YES];
                NSLog(@"%@", exception);
                return;
            }
            // Join thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [theTableView reloadData];
            });
        });
    }
    else {
        // Network Check Failed - Show Alert
        [self performSelectorOnMainThread:@selector(showNoNetworkAlert)
                               withObject:nil
                            waitUntilDone:YES];
        return;
    }
}

- (void)parseFeed:(TBXMLElement *)elem_NewRoot withPath:(NSString *)originalPath andDate:(NSString *)date{
    articleArray = [[NSMutableArray alloc] init];
    TBXMLElement *elem_ARTICLE = [TBXML childElementNamed:@"item"
                                            parentElement:elem_NewRoot];
    while (elem_ARTICLE != nil) {
        // Create a new article
        Article * art = [[Article alloc] init];
        
        // Get and store title
        TBXMLElement * elem_TITLE = [TBXML childElementNamed:@"title" parentElement:elem_ARTICLE];
        NSString *articleTitle = [TBXML textForElement:elem_TITLE];
        
        // Get and store article comments URL
        TBXMLElement * elem_COMMENTS = [TBXML childElementNamed:@"wfw:commentRss" parentElement:elem_ARTICLE];
        NSString *comments = [TBXML textForElement:elem_COMMENTS];
        NSURL *commentsURL = [NSURL URLWithString:comments];
        
        // Get and store article comment count
        TBXMLElement * elem_COMMENT_COUNT = [TBXML childElementNamed:@"slash:comments" parentElement:elem_ARTICLE];
        int commentCount = [[TBXML textForElement:elem_COMMENT_COUNT] intValue];
        
        // Get and store article body
        TBXMLElement * elem_TEXT = [TBXML childElementNamed:@"content:encoded" parentElement:elem_ARTICLE];
        NSString *articleBody = [TBXML textForElement:elem_TEXT];
        
        // Get and store image
        NSRange srcRange = [articleBody rangeOfString:@"src=\""];
        if (NSNotFound != srcRange.location) {
            // Get the URL's location
            NSRange endRange = [articleBody rangeOfString:@"\" width="];
            NSRange imgRange;
            imgRange.location = srcRange.location + srcRange.length;
            imgRange.length = endRange.location - imgRange.location;
            
            // Create the URL
            NSString *imageURLstring = [articleBody substringWithRange:imgRange];
            // Sanity Check
            if(imageURLstring != NULL){
                NSURL *imageURL = [[NSURL alloc] initWithString:imageURLstring];
                
                // Fetch the image
                art.image = [UIImage imageWithData:
                             [NSData dataWithContentsOfURL:imageURL]];
            }
        }
        
        // Remove HTML tags
        articleBody = [articleBody stringByReplacingOccurrencesOfString:@"<p>&nbsp;</p>\n"
                                                             withString:@""];
        art.title = [articleTitle stripHtml];
        art.article = [articleBody stripHtml];
        art.comments = commentsURL;
        art.commentsCount = commentCount;
        
        // Remove excess newline characters
        art.article = [art.article stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        while ([art.article rangeOfString:@"\n\n"].location != NSNotFound)
            art.article = [art.article stringByReplacingOccurrencesOfString:@"\n\n"
                                                                 withString:@"\n"];
        
        // Create "hard returns"
        art.article = [art.article stringByReplacingOccurrencesOfString:@"\n"
                                                             withString:@"\n\n"];
        
        // Add article to our array
        [articleArray addObject:art];
        
        // Get next article
        elem_ARTICLE = [TBXML nextSiblingNamed:@"item"
                             searchFromElement:elem_ARTICLE];
    }
    BOOL didWrite = [NSKeyedArchiver archiveRootObject:articleArray toFile:originalPath];
    if (!didWrite)
        NSLog(@"An error occurred writing the article cache");
    NSString *path = [originalPath stringByReplacingOccurrencesOfString:@"feed.plist" withString:@"feed-date.plist"];
    NSError *err;
    didWrite = [date writeToFile:path atomically:YES encoding:NSStringEncodingConversionAllowLossy error:&err];
    // If any error occured
    if (!didWrite)
        NSLog(@"An error occurred writing the date file: %@", err);
   // else NSLog(@"Wrote new date file");
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Rename the back button on the child view
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    self.cellIdentifier = @"NewsCell";
}

- (void)didReceiveMemoryWarning {
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
    // Register the NIB cell object for our custom cell
    [tableView registerNib:[UINib nibWithNibName:@"NewsCell" bundle:nil] forCellReuseIdentifier:self.cellIdentifier];
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
	}
    
    // Change highlight cell color
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor colorWithRed:142.0f/255.0f green:42.0f/255.0f blue:29.0f/255.0f alpha:1.0f]];
    [cell setSelectedBackgroundView:bgColorView];
    
    // Connect the cell's properties
    UILabel *newsTitle = (UILabel *)[cell viewWithTag:1001];
    UIImageView *newsImage = (UIImageView *)[cell viewWithTag:1002];
    UILabel *newsArticle = (UILabel *)[cell viewWithTag:1003];
    UILabel *largeNewsArticle = (UILabel *)[cell viewWithTag:1004];
    
    // Get the article for this cell
    Article *currentArticle = [[Article alloc] init];
    currentArticle = [articleArray objectAtIndex:indexPath.row];
    
    // Set the title
    newsTitle.text = currentArticle.title;
    
    // Create blurb that goes in table view
    NSString *newBody = [[NSString alloc] initWithString:currentArticle.article];
    newBody = ReplaceFirstNewLine(currentArticle.article);
    newBody = [newBody stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSRange newlineRange = [newBody rangeOfString:@"\n"];
    NSRange emailRange = [newBody rangeOfString:@"@grinnell.edu"];
    if (emailRange.location <= newlineRange.location)
        newBody = ReplaceEmail(newBody);
    newBody = [newBody stringByReplacingOccurrencesOfString:@"\n\n"
                                                 withString:@"\n"];
    
    // Set image and blurb based on whether an image is present or not
    if (currentArticle.image != nil){
        [newsImage setImage:currentArticle.image];
        newsImage.hidden = NO;
        newsArticle.text = newBody;
        newsArticle.hidden = NO;
        largeNewsArticle.hidden = YES;
    }
    else {
        newsImage.hidden = YES;
        largeNewsArticle.text = newBody;
        newsArticle.hidden = YES;
        largeNewsArticle.hidden = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 122;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleViewController *articlePage = [[ArticleViewController alloc] initWithNibName:@"ArticleViewController" bundle:nil];
    articlePage.article = [[Article alloc] init];
    articlePage.article = [articleArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:articlePage animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark String filtering methods
NSString * ReplaceFirstNewLine(NSString *original) {
    NSMutableString * newString = [NSMutableString stringWithString:original];
    NSRange foundRange = [original rangeOfString:@"\n"];
    if (foundRange.location >= 100 || foundRange.location == NSNotFound)
        return newString;
    NSRange newRange = foundRange;
    newRange.length = foundRange.location + 2;
    newRange.location = 0;
    
    [newString replaceCharactersInRange:newRange withString:@""];
    
    return newString;
}

NSString * ReplaceEmail(NSString *original) {
    NSMutableString * newString = [NSMutableString stringWithString:original];
    NSRange foundRange = [original rangeOfString:@"@grinnell.edu"];
    NSRange newRange = foundRange;
    newRange.length = foundRange.location + foundRange.length + 2;
    newRange.location = 0;
    
    if (foundRange.location != NSNotFound) {
        [newString replaceCharactersInRange:newRange
                                 withString:@""];
    }
    return newString;
}


#pragma mark UIAlertViewDelegate Methods
// Called when an alert button is tapped.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    return;
}

- (void)showNoNetworkAlert {
    UIAlertView *network = [[UIAlertView alloc]
                            initWithTitle:@"No Network Connection"
                            message:@"Turn on cellular data or use Wi-Fi to access new data from the server"
                            delegate:self
                            cancelButtonTitle:@"OK"
                            otherButtonTitles:nil
                            ];
    [network show];
}

- (void)showErrorAlert {
    UIAlertView *error = [[UIAlertView alloc]
                          initWithTitle:@"An Error Occurred"
                          message:@"Please try again later"
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil
                          ];
    [error show];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        // Return YES for supported orientations
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
    else
        return YES;
    // Use this to allow upside down as well
    //return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

@end


