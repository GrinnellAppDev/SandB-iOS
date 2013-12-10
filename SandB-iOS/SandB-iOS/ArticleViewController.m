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
@synthesize article, articleTitle, articleImage, articleBody, backgroundTitle, scroll, label;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
        ; // Customize here
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // Set the image behind the title
    backgroundTitle.backgroundColor = [UIColor colorWithPatternImage:
                                       [UIImage imageNamed:@"SANDB.png"]];
    
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
    articleTitle.text = article.title;

    // Set up the image and get the y offset for the text view
    CGFloat yPos;
    if (article.image != nil) {
        articleImage.hidden = NO;
        articleImage.image = article.image;
        yPos = articleImage.frame.size.height;
    }
    else {
        articleImage.hidden = YES;
        yPos = 0;
    }
    
    // Set up the text view so it doesn't scroll and add it to the scroll view
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:article.article];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Palatino" size:15] range:(NSMakeRange(0, article.article.length))];
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 16, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    CGFloat textHeight = rect.size.height;
    articleBody = [[UITextView alloc] initWithFrame:
                   CGRectMake(0, yPos, self.view.frame.size.width, textHeight + 8)];
    articleBody.text = article.article;
    articleBody.font = [UIFont fontWithName:@"Palatino" size:15];
    articleBody.editable = NO;
    //articleBody.scrollEnabled = NO;
    [scroll addSubview:articleBody];
    
    // Set the scroll view large enough to contain everything
    scroll.contentSize = CGSizeMake(self.view.frame.size.width, textHeight + 8 + yPos);
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
