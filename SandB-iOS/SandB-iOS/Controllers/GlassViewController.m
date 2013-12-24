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

#define SIDE_BAR_WIDTH 2

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
    int _tmpIndex;
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
    
    
    _viewScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width + 2*SIDE_BAR_WIDTH, self.view.frame.size.height)];
    [_viewScroller setPagingEnabled:YES];
    [_viewScroller setDelegate:self];
    [_viewScroller setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:_viewScroller];
    
    //Prepare all the glassScrolls. Refactored. Moved to ViewWillAppear as 1 single method.
    
    /*
    for (Article *article in self.articles) {
        BTGlassScrollView *glassScrollView = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:article.image blurredImage:nil viewDistanceFromBottom:120 foregroundView:[self customViewWithArticle:article]];
        
        [allGlassScrollViews addObject:glassScrollView];
        [_viewScroller addSubview:glassScrollView];
    }
    */
    
    /*
    [self.articles enumerateObjectsUsingBlock:^(Article *article, NSUInteger idx, BOOL *stop) {
        BTGlassScrollView *glassScrollView = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:article.image blurredImage:nil viewDistanceFromBottom:120 foregroundView:[self customViewWithArticle:article]];
        
        [allGlassScrollViews addObject:glassScrollView];
        [_viewScroller addSubview:glassScrollView];
    }];
     */
    
    
    
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
    
    [_viewScroller setFrame:CGRectMake(0, 0, self.view.frame.size.width + 2*SIDE_BAR_WIDTH, self.view.frame.size.height)];
    
 //   [_viewScroller setContentSize:CGSizeMake( allGlassScrollViews.count * _viewScroller.frame.size.width, self.view.frame.size.height)];
    
    /*
    [_glassScrollView1 setFrame:self.view.frame];
    [_glassScrollView2 setFrame:self.view.frame];
    [_glassScrollView3 setFrame:self.view.frame];
    */
    
    //[_glassScrollView2 setFrame:CGRectOffset(_glassScrollView2.bounds, _viewScroller.frame.size.width, 0)];
   // [_glassScrollView3 setFrame:CGRectOffset(_glassScrollView3.bounds, 2*_viewScroller.frame.size.width, 0)];
    
    /*
     Loop through all the articles. Create GlassScrollViews for each of them. Add them to the View Scroller at their correct
     locations. Update the View Scrollers content size.
     */
    [self.articles enumerateObjectsUsingBlock:^(Article *article, NSUInteger idx, BOOL *stop) {
        BTGlassScrollView *glassScrollView = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:article.image blurredImage:nil viewDistanceFromBottom:120 foregroundView:[self customViewWithArticle:article]];
        
        [allGlassScrollViews addObject:glassScrollView];
        [_viewScroller addSubview:glassScrollView];
        
        [glassScrollView setFrame:self.view.frame];
        [glassScrollView setFrame:CGRectOffset(glassScrollView.bounds, idx * _viewScroller.frame.size.width, 0)];
    }];
    
       [_viewScroller setContentSize:CGSizeMake( allGlassScrollViews.count * _viewScroller.frame.size.width, self.view.frame.size.height)];
    
    /*
    [allGlassScrollViews enumerateObjectsUsingBlock:^(BTGlassScrollView *glassScroll, NSUInteger idx, BOOL *stop) {
        [glassScroll setFrame:self.view.frame];
        [glassScroll setFrame:CGRectOffset(glassScroll.bounds, idx * _viewScroller.frame.size.width, 0)];
    }];
     */
    
    /*
    for (int i = 1; i < allGlassScrollViews.count; i++) {
        BTGlassScrollView *glassScroll = allGlassScrollViews[i];
        [glassScroll setFrame:self.view.frame];
        [glassScroll setFrame:CGRectOffset(glassScroll.bounds, i * _viewScroller.frame.size.width, 0)];
    }
     */
    
    
    //I'm not sure what this does... it was in his sample app. Leaving for now...
    [_viewScroller setContentOffset:CGPointMake(page * _viewScroller.frame.size.width, _viewScroller.contentOffset.y)];
    _page = page;
    
    //Keep track of a tmpIndex which lets us add to the scrollview after the user has swiped all the way to the right
    //and we download more data. _tmpIndex helps us know which index to add the new GlassScrollviews we created to.
    _tmpIndex = allGlassScrollViews.count;
    
    
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
    
    /*
    for (BTGlassScrollView *glassScroll in allGlassScrollViews) {
        [glassScroll setTopLayoutGuideLength:[self.topLayoutGuide length]];
    }
    */
    
    //Trying this to see if it increases performance. Update the autolayout stuff.
    [allGlassScrollViews enumerateObjectsUsingBlock:^(BTGlassScrollView *glassScroll, NSUInteger idx, BOOL *stop) {
        [glassScroll setTopLayoutGuideLength:[self.topLayoutGuide length]];
    }];
}

- (UIView *)customViewWithArticle:(Article *)article
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //Should rename this.. to ArticleViewController.. But it was being awkward the last time i tried.
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
    
    //NSLog(@"%i",_page);
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
    
    //More awkwardness....
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

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat ratio = scrollView.contentOffset.x/scrollView.frame.size.width;
    _page = (int)floor(ratio);
    
    
    if (_page == allGlassScrollViews.count - 2) {

        [self pullnewData];
        
    }
}

- (void)pullnewData
{
    
    //Simulate new data ready.
    NSMutableArray *newArticles = [NSMutableArray new];
    
    Article *a3 = [[Article alloc] init];
    a3.image = [UIImage imageNamed:@"thomas2.jpg"];
    a3.title = @"Thomas!!.";
    [self.articles addObject:a3];
    [newArticles addObject:a3];

    Article *a4 = [[Article alloc] init];
    a4.image = [UIImage imageNamed:@"town.jpg"];
    a4.title = @"Yes we can.";
    [self.articles addObject:a4];
    [newArticles addObject:a4];
    
    Article *a5 = [[Article alloc] init];
    a5.image = [UIImage imageNamed:@"rink.jpg"];
    a5.title = @"But I'm not that easy.";
    [self.articles addObject:a5];
    [newArticles addObject:a5];
    
    
    NSLog(@"tmpin: %d", _tmpIndex);
    
    [newArticles enumerateObjectsUsingBlock:^(Article *article, NSUInteger idx, BOOL *stop) {
        
        
        BTGlassScrollView *glassScrollView = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:article.image blurredImage:nil viewDistanceFromBottom:120 foregroundView:[self customViewWithArticle:article]];
        
        [allGlassScrollViews addObject:glassScrollView];
        [_viewScroller addSubview:glassScrollView];

        
        float width = CGRectGetWidth(_viewScroller.frame);
        int cIndx = idx + _tmpIndex;
        float newx = cIndx * width;
        
        
        //Ideally.. I'd like to use a one line like this... but it doesn't effing work for SOME reason. you can try it..
        //Maybe it's my device. So I used the newx created above... no idea why that works instead.
        //float newX = idx + _tmpIndex * CGRectGetWidth(_viewScroller.frame);
        

        [glassScrollView setFrame:self.view.frame];
        [glassScrollView setFrame:CGRectOffset(glassScrollView.bounds, newx, 0)];
        
        
    }];

    
    [_viewScroller setContentSize:CGSizeMake( allGlassScrollViews.count * _viewScroller.frame.size.width, self.view.frame.size.height)];
    

    _tmpIndex = allGlassScrollViews.count;
    
    
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


//Not sure what this does.. 
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
