//
//  GlassViewController.m
//  SandB-iOS
//
//  Created by Maijid Moujaled on 12/23/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import "GlassViewController.h"
#import "ArticleViewController.h"
#import "Article.h"
#import "TestArticleViewController.h"

@interface GlassViewController ()

@end

@implementation GlassViewController
{
    NSMutableArray *allGlassScrollViews;
    
    BTGlassScrollView *_glassScrollView;
    
    UIScrollView *_viewScroller;
    BTGlassScrollView *_glassScrollView1;
    BTGlassScrollView *_glassScrollView2;
    BTGlassScrollView *_glassScrollView3;
    int _page;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _page = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"art: %@", self.articles);
    allGlassScrollViews = [NSMutableArray new];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //preventing weird inset
    [self setAutomaticallyAdjustsScrollViewInsets: NO];
    
    //navigation bar work
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowOffset:CGSizeMake(1, 1)];
    [shadow setShadowColor:[UIColor blackColor]];
    [shadow setShadowBlurRadius:1];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSShadowAttributeName: shadow};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.title = @"Awesome App";
    
    //background
    self.view.backgroundColor = [UIColor blackColor];
    
    CGFloat blackSideBarWidth = 2;
    
    _viewScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width + 2*blackSideBarWidth, self.view.frame.size.height)];
    [_viewScroller setPagingEnabled:YES];
    [_viewScroller setDelegate:self];
    [_viewScroller setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:_viewScroller];
    
    //Prepare all the glassScrolls.
    
    for (Article *article in self.articles) {
        BTGlassScrollView *glassScrollView = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:article.image blurredImage:nil viewDistanceFromBottom:120 foregroundView:[self customViewWithArticle:article]];
        
        [allGlassScrollViews addObject:glassScrollView];
        [_viewScroller addSubview:glassScrollView];
    }
    
    
    
 /*
    _glassScrollView1 = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:@"thomas2.jpg"] blurredImage:nil viewDistanceFromBottom:120 foregroundView:[self customView]];
    _glassScrollView2 = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:@"game.jpg"] blurredImage:nil viewDistanceFromBottom:120 foregroundView:[self customView]];
    _glassScrollView3 = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:@"rink.jpg"] blurredImage:nil viewDistanceFromBottom:120 foregroundView:[self customView]];
    
    [_viewScroller addSubview:_glassScrollView1];
    [_viewScroller addSubview:_glassScrollView2];
    [_viewScroller addSubview:_glassScrollView3];
    
*/
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    int page = _page; // resize scrollview can cause setContentOffset off for no reason and screw things up
    
    CGFloat blackSideBarWidth = 2;
    [_viewScroller setFrame:CGRectMake(0, 0, self.view.frame.size.width + 2*blackSideBarWidth, self.view.frame.size.height)];
    NSLog(@"count: %d", allGlassScrollViews.count);
    
    [_viewScroller setContentSize:CGSizeMake( allGlassScrollViews.count * _viewScroller.frame.size.width, self.view.frame.size.height)];
    
    [_glassScrollView1 setFrame:self.view.frame];
    [_glassScrollView2 setFrame:self.view.frame];
    [_glassScrollView3 setFrame:self.view.frame];
    
    
    //[_glassScrollView2 setFrame:CGRectOffset(_glassScrollView2.bounds, _viewScroller.frame.size.width, 0)];
   // [_glassScrollView3 setFrame:CGRectOffset(_glassScrollView3.bounds, 2*_viewScroller.frame.size.width, 0)];
    
    
    
    for (int i = 1; i < allGlassScrollViews.count; i++) {
        BTGlassScrollView *glassScroll = allGlassScrollViews[i];
        [glassScroll setFrame:self.view.frame];
        [glassScroll setFrame:CGRectOffset(glassScroll.bounds, i * _viewScroller.frame.size.width, 0)];

    }
    
    
    [_viewScroller setContentOffset:CGPointMake(page * _viewScroller.frame.size.width, _viewScroller.contentOffset.y)];
    _page = page;
    
    
}

- (void)viewWillLayoutSubviews
{
    // if the view has navigation bar, this is a great place to realign the top part to allow navigation controller
    // or even the status bar
    
    /*
    [_glassScrollView1 setTopLayoutGuideLength:[self.topLayoutGuide length]];
    [_glassScrollView2 setTopLayoutGuideLength:[self.topLayoutGuide length]];
    [_glassScrollView3 setTopLayoutGuideLength:[self.topLayoutGuide length]];
    */
    
    for (BTGlassScrollView *glassScroll in allGlassScrollViews) {
        [glassScroll setTopLayoutGuideLength:[self.topLayoutGuide length]];
    }
}

- (UIView *)customViewWithArticle:(Article *)article
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ArticleViewController *articleViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainArticleViewController"];
    articleViewController.article = article; 
    
    NSLog(@"av: %@", articleViewController);
    
    
    
//    return articleViewController.view;
    
    TestArticleViewController *tvc = [storyboard instantiateViewControllerWithIdentifier:@"TestViewController"];
    tvc.article = article; 
    return tvc.view;
}

/*
- (UIView *)customView
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ArticleViewController *articleViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainArticleViewController"];
    
    
    return articleViewController.view;
 
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 705)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 120)];
    [label setText:[NSString stringWithFormat:@"%i℉",arc4random_uniform(20) + 60]];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120]];
    [label setShadowColor:[UIColor blackColor]];
    [label setShadowOffset:CGSizeMake(1, 1)];
    [view addSubview:label];
    
    UIView *box1 = [[UIView alloc] initWithFrame:CGRectMake(5, 140, 310, 125)];
    box1.layer.cornerRadius = 3;
    box1.backgroundColor = [UIColor colorWithWhite:0 alpha:.15];
    [view addSubview:box1];
    
    UIView *box2 = [[UIView alloc] initWithFrame:CGRectMake(5, 270, 310, 300)];
    box2.layer.cornerRadius = 3;
    box2.backgroundColor = [UIColor colorWithWhite:0 alpha:.15];
    [view addSubview:box2];
    
    UIView *box3 = [[UIView alloc] initWithFrame:CGRectMake(5, 575, 310, 125)];
    box3.layer.cornerRadius = 3;
    box3.backgroundColor = [UIColor colorWithWhite:0 alpha:.15];
    [view addSubview:box3];
    
    return view;
 
}
*/

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat ratio = scrollView.contentOffset.x/scrollView.frame.size.width;
    _page = (int)floor(ratio);
    NSLog(@"%i",_page);
    /*
    if (ratio > -1 && ratio < 1) {
        [_glassScrollView1 scrollHorizontalRatio:-ratio];
    }
    if (ratio > 0 && ratio < 2) {
        [_glassScrollView2 scrollHorizontalRatio:-ratio + 1];
    }
    if (ratio > 1 && ratio < 3) {
        [_glassScrollView3 scrollHorizontalRatio:-ratio + 2];
    }
    */
    int lowerRatio = -1;
    int upperRatio = 1;
    
    for (int i = 0; i < allGlassScrollViews.count; i++) {
        
        BTGlassScrollView *glassScroll = allGlassScrollViews[i];
        int lower = lowerRatio + i;
        int upper = upperRatio + i;
        if (ratio > lower && ratio < upper) {
            [glassScroll scrollHorizontalRatio:-ratio + i];

        }
        
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    BTGlassScrollView *glass = [self currentGlass];
    
    //can probably be optimized better than this
    //this is just a demonstration without optimization
    [_glassScrollView1 scrollVerticallyToOffset:glass.foregroundScrollView.contentOffset.y];
    [_glassScrollView2 scrollVerticallyToOffset:glass.foregroundScrollView.contentOffset.y];
    [_glassScrollView3 scrollVerticallyToOffset:glass.foregroundScrollView.contentOffset.y];
}

- (BTGlassScrollView *)currentGlass
{
    BTGlassScrollView *glass;
    switch (_page) {
        case 0:
            glass = _glassScrollView1;
            break;
        case 1:
            glass = _glassScrollView2;
            break;
        case 2:
            glass = _glassScrollView3;
        default:
            break;
    }
    return glass;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self viewWillAppear:YES];
}


@end
