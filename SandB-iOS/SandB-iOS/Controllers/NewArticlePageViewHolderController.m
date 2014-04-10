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

@interface NewArticlePageViewHolderController ()

@property (nonatomic, strong) Article *currentArticle;
@property (nonatomic) NSUInteger index;

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
    
    self.pageArticles = [[DataModel sharedModel] articles];
    
    // Do any additional setup after loading the view.
    
    // Page View Controller Setup
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewArticlePageViewController"];
    //NSLog(@"Data source is: %@", self.infoPageViewController)
    self.pageViewController.dataSource = self;
    
    NewArticleViewController *startingViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
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
    
    // methods that notify this view from the NewArticleViewController that the table view scrolled to a certain break point
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorTopBar) name:@"ColorTopBar" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uncolorTopBar) name:@"UncolorTopBar" object:nil];
    
    // Set pageview delegate to self
    self.pageViewController.delegate = self;
    
    // DO STUFF WITH THE API
    // http://thesandb.com/api/get_category_posts + GET + JSON encoded id
    // 3 - News
    // 216 - Community
    // 5 - Arts
    // 6 - Features
    
    

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
                                                                                       
#pragma mark - Page View Controller methods

- (IBAction)startWalkthrough {
    NewArticleViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    [self viewDidLoad];
}

- (NewArticleViewController *) viewControllerAtIndex:(NSUInteger) index {
    if (([self.pageArticles count] == 0) || (index >= [self.pageArticles count])) {
        return nil;
    }
    
    NewArticleViewController *navc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewArticleViewController"];
    
    Article *article = self.pageArticles[self.articleIndex];
    
    navc.article = article;
    navc.pageIndex = index;
    
    NSLog(@"the current index: %i", self.articleIndex);
    
    return navc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    // NSUInteger index = ((NewArticleViewController *) viewController).pageIndex;
    
//    if (index == 0 || (index == NSNotFound)) {
//        return nil;
//    }
//    
//    index--;
//    return [self viewControllerAtIndex:index];
    
    if (self.articleIndex == 0 || (self.articleIndex == NSNotFound)) {
        return nil;
    }
    
    self.articleIndex--;
    return [self viewControllerAtIndex:self.articleIndex];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    //NSUInteger index = ((NewArticleViewController *) viewController).pageIndex;
    
//    if (index == NSNotFound) {
//        return nil;
//    }
//    
//    index++;
    
    if (self.articleIndex == NSNotFound) {
        return nil;
    }
    
    self.articleIndex++;
    
    return [self viewControllerAtIndex:self.articleIndex];
}

#pragma mark - Status Bar Options

- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (IBAction)popViewController:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)colorTopBar {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.topBarView.backgroundColor = [UIColor whiteColor];
        self.redSeparator.alpha = 1;
    }];
    
    [self colorButtonsForRenderingMode:UIImageRenderingModeAlwaysTemplate andControlState:UIControlStateNormal];
}

-(void)uncolorTopBar {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.topBarView.backgroundColor = [UIColor clearColor];
        self.redSeparator.alpha = 0;
    }];
    
    [self colorButtonsForRenderingMode:UIImageRenderingModeAutomatic andControlState:UIControlStateNormal];

}

// changing the color of the buttons

-(void) colorButtonsForRenderingMode:(UIImageRenderingMode *) mode andControlState:(UIControlState *) state{
    
    self.view.tintColor = [UIColor colorWithRed:140.0/255 green:29.0/255 blue:41.0/255 alpha:1.0];
    
    [self.backButton setImage:[[UIImage imageNamed:@"BackButtonWhite"]imageWithRenderingMode:mode] forState:state];
    [self.chatButton setImage:[[UIImage imageNamed:@"ChatIconWhite"]imageWithRenderingMode:mode] forState:state];
    [self.starButton setImage:[[UIImage imageNamed:@"StarIconWhite"]imageWithRenderingMode:mode] forState:state];
    [self.shareButton setImage:[[UIImage imageNamed:@"ShareIconWhite"]imageWithRenderingMode:mode] forState:state];
    [self.editTextButton setImage:[[UIImage imageNamed:@"EditTextIconWhite"]imageWithRenderingMode:mode] forState:state];
    
    // TO DO: Change Color When Button Pressed
}

- (IBAction)favoriteButtonPressed:(id)sender {
    NSLog(@"I am favoriting the current article - %@", self.currentArticle.title);
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    NewArticleViewController *theCurrentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
    
    NSInteger theIndex = [self.pageArticles indexOfObject:theCurrentViewController.article];
    
    self.currentArticle  = self.pageArticles[theIndex];

}

@end
