//
//  ArticleViewController.m
//  SandB-iOS
//
//  Created by Lea Marolt on 1/27/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import "ArticleViewController.h"
#import "CommentsViewController.h"

@interface ArticleViewController ()

@end

@implementation ArticleViewController

@synthesize article, articleTitle, articleImage, articleBody, scroll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
        ; // Customize here
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // Make the comments button
    if (article.commentsCount) {
        UIBarButtonItem *commentsBtn = [[UIBarButtonItem alloc] initWithTitle:@"Comments" style:UIBarButtonItemStylePlain target:self action:@selector(commentsBtnTapped:)];
        self.navigationItem.rightBarButtonItem = commentsBtn;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Set up the article body, title, and image
    //  These have to go here so that the frame size is correct!
    int padding = 8;

    // Set up article title and add it to the view
    NSMutableAttributedString *titleAttrs = [[NSMutableAttributedString alloc] initWithString:article.title];
    [titleAttrs addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Georgia-Bold" size:18] range:(NSMakeRange(0, article.title.length))];
    CGRect titleRect = [titleAttrs boundingRectWithSize:CGSizeMake(self.view.frame.size.width - padding * 2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    articleTitle = [[UILabel alloc] initWithFrame:CGRectMake(padding, 0 + padding * 2, self.view.frame.size.width - padding * 2, titleRect.size.height)];
    [articleTitle setNumberOfLines:0];
    [articleTitle setFont:[UIFont fontWithName:@"Georgia-Bold" size:18]];
    [articleTitle setTextColor:[UIColor colorWithRed:0.5f green:0.0f blue:0.0f alpha:1.0f]];
    [articleTitle setText:article.title];
    [self.view addSubview:articleTitle];

    // Set up scroll view
    int offset = articleTitle.frame.size.height + articleTitle.frame.origin.y + padding * 2;
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, offset, self.view.frame.size.width, self.view.frame.size.height - offset)];
    
    // Set up the image and add it to the scroll view
    if (article.image != nil) {
        articleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
        [articleImage setImage:article.image];
        [articleImage setContentMode:UIViewContentModeScaleAspectFit];
        offset = articleImage.frame.size.height;
        [scroll addSubview:articleImage];
    }
    else
        offset = 0;
    
    // Set up the label and add it to the scroll view
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:article.article];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Palatino" size:15] range:(NSMakeRange(0, article.article.length))];
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(self.view.frame.size.width - padding * 2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    CGFloat textHeight = rect.size.height;
    articleBody = [[UILabel alloc] initWithFrame:CGRectMake(padding, offset + padding * 2, self.view.frame.size.width - padding * 2, textHeight)];
    [articleBody setNumberOfLines:0];
    [articleBody setFont:[UIFont fontWithName:@"Palatino" size:15]];
    [articleBody setText:article.article];
    [scroll addSubview:articleBody];
    
    // Set the scroll view large enough to contain everything
    scroll.contentSize = CGSizeMake(self.view.frame.size.width, articleBody.frame.origin.y + articleBody.frame.size.height + padding);
    
    // Add scroll view to view
    [self.view addSubview:scroll];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

- (void)commentsBtnTapped:(id)sender {
    CommentsViewController *commentsVC = [[CommentsViewController alloc] initWithNibName:@"CommentsViewController" bundle:nil];
    commentsVC.url = article.comments;
    [self.navigationController pushViewController:commentsVC animated:YES];
}

@end
