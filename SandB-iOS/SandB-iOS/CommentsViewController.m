//
//  CommentsViewController.m
//  SandB-iOS
//
//  Created by Colin Tremblay on 12/10/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import "CommentsViewController.h"
#import "ArticleViewController.h"
#import <MBProgressHUD.h>
#import <Reachability.h>
#import "Comment.h"
#import "NSString_stripHtml.h"

@interface CommentsViewController ()

@end

@implementation CommentsViewController

@synthesize url, theTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.cellIdentifier = @"CommentsCell";

    [self loadComments];
}

- (void)loadComments {
    NSString *originalTempPath = NSTemporaryDirectory();
    
    NSString *urlForOriginalPath = [[NSString stringWithFormat:@"%@", url] stringByReplacingOccurrencesOfString:@"http://www.thesandb.com/" withString:@""];
    urlForOriginalPath = [urlForOriginalPath stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    NSString *originalFeed = [NSString stringWithFormat:@"%@.plist", urlForOriginalPath];
    NSString *originalPath = [originalTempPath stringByAppendingPathComponent:originalFeed];
    
    // NSLog(@"About to test for cached article file called: %@", originalPath);
    if ([[NSFileManager defaultManager] fileExistsAtPath:originalPath]) {
        commentsArray = [NSKeyedUnarchiver unarchiveObjectWithFile:originalPath];
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
                NSData *xmlData = [[NSData alloc]initWithContentsOfURL:url];
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
    commentsArray = [[NSMutableArray alloc] init];
    TBXMLElement *elem_COMMENT = [TBXML childElementNamed:@"item"
                                            parentElement:elem_NewRoot];
    while (elem_COMMENT != nil) {
        // Create a new article
        Comment *tempComment = [[Comment alloc] init];
        
        // Get and store title
        TBXMLElement *elem_TITLE = [TBXML childElementNamed:@"title" parentElement:elem_COMMENT];
        NSString *author = [TBXML textForElement:elem_TITLE];
        
        // Get and store date/time
        TBXMLElement *elem_TIMESTAMP = [TBXML childElementNamed:@"pubDate" parentElement:elem_COMMENT];
        NSString *timestamp = [TBXML textForElement:elem_TIMESTAMP];
        timestamp = [timestamp stringByReplacingOccurrencesOfString:@" +0000" withString:@""];
        
        // Get and store comment
        TBXMLElement *elem_CONTENT = [TBXML childElementNamed:@"content:encoded" parentElement:elem_COMMENT];
        NSString *comment = [TBXML textForElement:elem_CONTENT];
        
        // Remove HTML tags
        comment = [comment stringByReplacingOccurrencesOfString:@"<p>&nbsp;</p>\n"
                                                             withString:@""];
        
        tempComment.text = [comment stripHtml];;
        tempComment.author = [author stripHtml];
        tempComment.timestamp = [timestamp stripHtml];
        NSLog(@"%@", tempComment.text);
        
        // Add article to our array
        [commentsArray addObject:tempComment];
        
        // Get next article
        elem_COMMENT = [TBXML nextSiblingNamed:@"item"
                             searchFromElement:elem_COMMENT];
    }
    BOOL didWrite = [NSKeyedArchiver archiveRootObject:commentsArray toFile:originalPath];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return commentsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Get the comment for this cell
    Comment *currentComment = [[Comment alloc] init];
    currentComment = [commentsArray objectAtIndex:indexPath.row];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:currentComment.text];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline] range:(NSMakeRange(0, currentComment.text.length))];
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 40, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    CGFloat textHeight = rect.size.height;
    return textHeight + 98;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Register the NIB cell object for our custom cell
    [tableView registerNib:[UINib nibWithNibName:@"CommentsCell" bundle:nil] forCellReuseIdentifier:self.cellIdentifier];
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
	}
    
    // Connect the cell's properties
    UILabel *authorLbl = (UILabel *)[cell viewWithTag:8001];
    UILabel *timeLbl = (UILabel *)[cell viewWithTag:8002];
    UILabel *textLbl = (UILabel *)[cell viewWithTag:8003];
    
    // Get the comment for this cell
    Comment *currentComment = [[Comment alloc] init];
    currentComment = [commentsArray objectAtIndex:indexPath.row];
    
    // Set the author
    authorLbl.text = currentComment.author;
    
    // Set the timestamp
    timeLbl.text = currentComment.timestamp;
    
    // Set the Comment Text
    textLbl.text = currentComment.text;
    
    return cell;
}

//Method to determine the availability of network Connections using the Reachability Class
- (BOOL)networkCheck {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    return (!(networkStatus == NotReachable));
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

@end
