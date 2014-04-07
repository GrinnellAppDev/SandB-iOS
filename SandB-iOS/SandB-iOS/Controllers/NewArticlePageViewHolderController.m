//
//  NewArticlePageViewHolderController.m
//  SandB-iOS
//
//  Created by Lea Marolt on 4/6/14.
//  Copyright (c) 2014 Grinnell AppDev. All rights reserved.
//

#import "NewArticlePageViewHolderController.h"
#import "Article.h"

@interface NewArticlePageViewHolderController ()

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
    
    self.pageArticles = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 10; i++) {
        Article *article = [[Article alloc] init];
        article.title = [NSString stringWithFormat:@"Article Title: %d", i];
        article.content = @"Biggest baddest content the world as ever seen!!! Biggest baddest content the world as ever seen!!! Biggest baddest content the world as ever seen!!! Biggest baddest content the world as ever seen!!! Biggest baddest content the world as ever seen!!! Biggest baddest content the world as ever seen!!! Biggest baddest content the world as ever seen!!! Biggest baddest content the world as ever seen!!! Biggest baddest content the world as ever seen!!! Biggest baddest content the world as ever seen!!! Biggest baddest content the world as ever seen!!! Biggest baddest content the world as ever seen!!! Biggest baddest content the world as ever seen!!! Biggest baddest content the world as ever seen!!! Biggest baddest content the world as ever seen!!! Biggest baddest content the world as ever seen!!! Biggest baddest content the world as ever seen!!! Biggest baddest content the world as ever seen!!! Biggest baddest content the world as ever seen!!! Biggest baddest content the world as ever seen!!! Biggest baddest content the world as ever seen!!! Biggest baddest content the world as ever seen!!! Biggest baddest content the world as ever seen!!! Biggest baddest content the world as ever seen!!! Biggest baddest content the world as ever seen!!! Biggest baddest content the world as ever seen!!! Biggest baddest content the world as ever seen!!! Biggest baddest content the world as ever seen!!!";
        //put in array
        [self.pageArticles addObject:article];
        
        //self.topBarView.layer.zPosition = 1;
    }
    
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
    
    // changing the color of the buttons

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
    
    NewArticleViewController *nwvc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewArticleViewController"];
    
    Article *article = self.pageArticles[index];
    
    nwvc.article = article;
    nwvc.pageIndex = index;
    
    return nwvc;
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
    
    return [self viewControllerAtIndex:index];
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
    
    [self colorButtons];
}

-(void)uncolorTopBar {
    [UIView animateWithDuration:0.3 animations:^{
        self.topBarView.backgroundColor = [UIColor clearColor];
        self.redSeparator.alpha = 0;
    }];
    
    [self uncolorButtons];
}

-(void) colorButtons {
    self.view.tintColor = [UIColor colorWithRed:140.0/255 green:29.0/255 blue:41.0/255 alpha:1.0];
    
    self.backButton.imageView.image = [[UIImage imageNamed:@"BackButtonWhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.chatButton.imageView.image = [[UIImage imageNamed:@"ChatIconWhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.starButton.imageView.image = [[UIImage imageNamed:@"StarIconWhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.shareButton.imageView.image = [[UIImage imageNamed:@"ShareIconWhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.editTextButton.imageView.image = [[UIImage imageNamed:@"EditTextIconWhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

-(void) uncolorButtons {
    
    self.backButton.imageView.image = [[UIImage imageNamed:@"BackButtonWhite"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    self.chatButton.imageView.image = [[UIImage imageNamed:@"ChatIconWhite"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    self.starButton.imageView.image = [[UIImage imageNamed:@"StarIconWhite"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    self.shareButton.imageView.image = [[UIImage imageNamed:@"ShareIconWhite"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    self.editTextButton.imageView.image = [[UIImage imageNamed:@"EditTextIconWhite"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
}

@end
