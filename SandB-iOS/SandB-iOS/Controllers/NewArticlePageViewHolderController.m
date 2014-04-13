//
//  NewArticlePageViewHolderController.m
//  SandB-iOS
//
//  Created by Lea Marolt on 4/6/14.
//  Copyright (c) 2014 Grinnell AppDev. All rights reserved.
//

#import "NewArticlePageViewHolderController.h"
#import "Article.h"
#import "DataModel.h"
#import "ShareMZModalViewController.h"
#import "ShareModalViewController.h"
#import "TextOptionModalViewController.h"
#import "UIPageViewController+ReloadData.h"

#import "MZFormSheetController.h"
#import "MZCustomTransition.h"
#import "MZFormSheetSegue.h"

@interface NewArticlePageViewHolderController ()
@property (nonatomic, strong) Article *currentArticle;
@property (nonatomic) NSUInteger index;
@property (nonatomic, assign) BOOL isFetchingArticles;

// Reading Options
@property (nonatomic, assign) float fontSize;
@property (nonatomic, strong) NSString *fontFamily;
@property (nonatomic, assign) BOOL isLightTheme;

@end

@implementation NewArticlePageViewHolderController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPages) name:@"ReloadPageViewController" object:nil];
    
    if ([self.recievedCategoryString isEqualToString:@"News"]) {
        self.pageArticles = [[DataModel sharedModel] articles];
    }
    else {
        self.pageArticles =  [[DataModel sharedModel] categoryArrayForCategoryName:self.recievedCategoryString];
    }
    
    // Do any additional setup after loading the view.
    
    // Page View Controller Setup
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewArticlePageViewController"];
    //NSLog(@"Data source is: %@", self.infoPageViewController)
    self.pageViewController.dataSource = self;
    
    NewArticleViewController *startingViewController = [self viewControllerAtIndex:self.articleIndex];
    
    NSArray *viewControllers = @[startingViewController];
    //[self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Bug in PageViewController with Scroll. http://stackoverflow.com/questions/13633059/uipageviewcontroller-how-do-i-correctly-jump-to-a-specific-page-without-messing
    __weak UIPageViewController * _weakPageViewController = self.pageViewController;
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES completion:^(BOOL finished) {
                                           UIPageViewController* pvcs = _weakPageViewController;
                                           if (!pvcs) return;
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [pvcs setViewControllers:viewControllers
                                                              direction:UIPageViewControllerNavigationDirectionForward
                                                               animated:NO completion:nil];
                                           });
                                       }];
    
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    [self.view bringSubviewToFront:self.topBarView];
    
    // get rid of swiping back
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    // get rid of nav bar + status bar
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
    // Methods that notify this view from the NewArticleViewController that the table view scrolled to a certain break point
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorTopBar) name:@"ColorTopBar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uncolorTopBar) name:@"UncolorTopBar" object:nil];
    
    // Set pageview delegate to self
    self.pageViewController.delegate = self;
    
    // DO STUFF WITH THE API
    // http://thesandb.com/api/get_category_posts + GET + JSON encoded id
    // 3 - News
    // 5 - Arts
    // 216 - Community
    // 6 - Features
    // 4 - Opinion
    // 7 - Sports
    
    // MODAL VIEW STUFF
    
    [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
    [[MZFormSheetBackgroundWindow appearance] setBlurRadius:5.0];
    [[MZFormSheetBackgroundWindow appearance] setBackgroundColor:[UIColor clearColor]];
    
    [MZFormSheetController registerTransitionClass:[MZCustomTransition class] forTransitionStyle:MZFormSheetTransitionStyleCustom];
    
    [self loadReadingOptions];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)loadReadingOptions
{
    self.fontSize = [[NSUserDefaults standardUserDefaults] floatForKey:@"ReadingOptionsFontSize"];
    self.fontFamily = [[NSUserDefaults standardUserDefaults] objectForKey:@"ReadingOptionsFontFamily"];
    self.isLightTheme = [[NSUserDefaults standardUserDefaults] boolForKey:@"ReadingOptionsIsLightTheme"];
}

#pragma mark - Page View Controller methods

- (NewArticleViewController *) viewControllerAtIndex:(NSUInteger) index {
    if (([self.pageArticles count] == 0) || (index >= [self.pageArticles count])) {
        return nil;
    }
    
    [self loadReadingOptions];
    
    NewArticleViewController *navc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewArticleViewController"];
    
    /*
    if (self.isLightTheme) {
        NSLog(@"is light them");
        navc.theTableView.backgroundColor = [UIColor whiteColor];
    } else {
        NSLog(@"is dark them");
        navc.view.backgroundColor = [UIColor blackColor];
    }
    */
    
    
    Article *article = self.pageArticles[index];
    
    NSLog(@"fs: %f", self.fontSize);
    NSLog(@"ff: %@", self.fontFamily);
    
    // Modify the article right here.
    
    //Get default values.
    
    // NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline],
    //  NSFontAttributeName: [UIFont fontWithName:@"Palatino" size:14.0f],
    
    // size ranges from 100% to 200%.
    // Helvetica Neue || Avenir Next || Cochin
   
//    for (NSString* family in [UIFont familyNames])
//    {
//        NSLog(@"%@", family);
//        
//        for (NSString* name in [UIFont fontNamesForFamilyName: family])
//        {
//            NSLog(@"  %@", name);
//        }
//    }
// #FFF
    
     NSString *htmlOpen = @"<html>";
     NSString *htmlClose = @"</html>";
    int fontSize = (self.fontSize * 100) + 100;
    NSString * htmlAdditions  =  [NSString stringWithFormat:@"<head><style type='text/css'> body{font-size: %d%%;font-family:'%@';color:#4A4A4A;}</style></head>", fontSize, self.fontFamily];

//     NSString *htmlAdditions = @"<head><style type='text/css'> body{font-size: 180%;font-family:'Cochin';color:#4A4A4A;}</style></head>";
     NSString *newContent =  [NSString stringWithFormat:@"%@%@ %@%@",htmlOpen, htmlAdditions, article.content, htmlClose];
    
     NSError *error = nil;
     
     NSDictionary *options = @{
     NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
     };
     
     
     article.attrContent = [[NSMutableAttributedString alloc] initWithData:[newContent dataUsingEncoding:NSUTF32StringEncoding]
     options:options documentAttributes:nil
     error:&error];
     
    
    
    
    
    /* NSDictionary* attributes = @{
                                NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline],
                                
                                 }; */
    
    //[article.attrContent addAttributes:attributes range:NSMakeRange(0, [article.attrContent length])];
    
    //NSLog(@"attrContent: %@", article.attrContent);
    
    navc.article = article;
    navc.pageIndex = index;
    
    return navc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = ((NewArticleViewController *) viewController).pageIndex;
    
    if (index == 0 || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = ((NewArticleViewController *) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    
    if (self.articleIndex == NSNotFound) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}


- (void)reloadPages
{
    NSLog(@"Reloading");
    [self.pageViewController xcd_setViewControllers:self.pageViewController.viewControllers direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES completion:nil];
}

#pragma mark - Downloading Data

- (void) fetchArticles {
    
    [[DataModel sharedModel] fetchArticlesWithCompletionBlock:^(NSMutableArray *articles, NSMutableArray *newArticles, int totalPages, int currentPage, NSError *error) {
        if (!error) {
            
            // TODO (DrJid): Handle when _currentPage < totalPages :: Honestly... there are like... 3K articles... we'd never get to this point now would we...
            
            //_currentPage = currentPage;
            //_totalPages = totalPages;
            //[self.tableView reloadData];
            self.pageArticles = articles;
        }
        else {
            NSLog(@"I am sad!");
        }
        self.isFetchingArticles = NO;
    }];
    
}

- (void) fetchCategoryArticles {
    
    [[DataModel sharedModel] fetchArticlesForCategory:self.recievedCategoryString withCompletionBlock:
     ^(NSMutableArray *articles, NSMutableArray *newArticles, int totalPages, int currentPage, NSError *error) {
         if (!error) {
             // TODO (DrJid): Same as above
             //_currentPage = currentPage;
             //_totalPages = totalPages;
             //[self.tableView reloadData];
             self.pageArticles = articles;
         }
         else {
             NSLog(@"I am sad!");
         }
         self.isFetchingArticles = NO;
     }];
}

- (void)fetchArticlesForView {
    if (!self.isFetchingArticles) {
        self.isFetchingArticles = YES;
        NSLog(@"Fetching!!!");
        
        if ([self.recievedCategoryString isEqualToString:@"News"]) {
            [self fetchArticles];
        }
        else {
            [self fetchCategoryArticles];
        }
    }
}

#pragma mark - Status Bar Options

- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (IBAction)popViewController:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)colorTopBar {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.topBarView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
        self.redSeparator.alpha = 1;
    }];
    
    [self colorButtonsForRenderingMode:UIImageRenderingModeAlwaysTemplate andControlState:UIControlStateNormal];
}

- (void)uncolorTopBar {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.topBarView.backgroundColor = [UIColor clearColor];
        self.redSeparator.alpha = 0;
    }];
    
    [self colorButtonsForRenderingMode:UIImageRenderingModeAutomatic andControlState:UIControlStateNormal];
    
}

// changing the color of the buttons

- (void) colorButtonsForRenderingMode:(UIImageRenderingMode *) mode andControlState:(UIControlState *) state {
    
    self.view.tintColor = [UIColor colorWithRed:140.0/255 green:29.0/255 blue:41.0/255 alpha:1.0];
    
    [self.backButton setImage:[[UIImage imageNamed:@"BackButtonWhite"]imageWithRenderingMode:mode] forState:state];
    [self.chatButton setImage:[[UIImage imageNamed:@"ChatIconWhite"]imageWithRenderingMode:mode] forState:state];
    [self.starButton setImage:[[UIImage imageNamed:@"StarIconWhite"]imageWithRenderingMode:mode] forState:state];
    [self.shareButton setImage:[[UIImage imageNamed:@"ShareIconWhite"]imageWithRenderingMode:mode] forState:state];
    [self.editTextButton setImage:[[UIImage imageNamed:@"EditTextIconWhite"]imageWithRenderingMode:mode] forState:state];
    
    // TO DO: Change Color When Button Pressed
}

- (IBAction)favoriteButtonPressed:(id)sender
{
    
}

- (IBAction)shareButtonPressed:(id)sender {
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
    NewArticleViewController *theCurrentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
    NSInteger theIndex = [self.pageArticles indexOfObject:theCurrentViewController.article];
    self.currentArticle  = self.pageArticles[theIndex];
    [self.currentArticle setRead:YES];
    
    
    NSLog(@"theINdex: %d|| count: %lu", theIndex, self.pageArticles.count);
    if (theIndex > self.pageArticles.count - 5) {
        // Go fetch more data. and update the self.pageArticles array;
        [self fetchArticlesForView];
    }
}

// MZ Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // setup the segue
    MZFormSheetSegue *formSheetSegue = (MZFormSheetSegue *)segue;
    MZFormSheetController *formSheet = formSheetSegue.formSheetController;
    formSheet.transitionStyle = MZFormSheetTransitionStyleFade;
    formSheet.cornerRadius = 0;
    formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
        
    };
    
    
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    
    formSheet.didPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
        
    };
    
    // depending on where we're going do more setup
    if ([segue.identifier isEqualToString:@"shareModal"]) {
        formSheet.presentedFormSheetSize = CGSizeMake(290, 370);
        
        formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
            // Passing data
            ShareModalViewController *smvc = (ShareModalViewController *)presentedFSViewController;
            if (self.currentArticle) {
                smvc.article = self.currentArticle;
            }
            else {
                smvc.article = self.pageArticles[self.articleIndex];                
            }
        };
        
        
    }
    
    if ([segue.identifier isEqualToString:@"textOptionModal"]) {
        formSheet.presentedFormSheetSize = CGSizeMake(306, 168);
    }
}

@end
