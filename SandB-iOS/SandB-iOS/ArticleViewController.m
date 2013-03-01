//
//  ArticleViewController.m
//  SandB-iOS
//
//  Created by Lea Marolt on 1/27/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import "ArticleViewController.h"

@interface ArticleViewController ()

@end

@implementation ArticleViewController
@synthesize article, articleTitle, articleImage, articleBody, backgroundTitle, scroll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
        ; // Customize here
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up the swipe right gesture
    UISwipeGestureRecognizer *swipeRight =
        [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(handleSwipeRight)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
    
    // Set the image behind the title
    backgroundTitle.backgroundColor = [UIColor colorWithPatternImage:
                                       [UIImage imageNamed:@"SANDB.png"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Set up the article body, title, and image
    //  These have to go here so that the frame size is correct!
    articleTitle.text = article.title;
    
    // Get the needed height for the text view (so it doesn't scroll)
    CGSize textViewSize = [article.article sizeWithFont:[UIFont fontWithName:@"Palatino" size:15]
                                      constrainedToSize:CGSizeMake(self.view.frame.size.width - 16,
                                                                   FLT_MAX)
                                          lineBreakMode:UILineBreakModeWordWrap];
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
    articleBody = [[UITextView alloc] initWithFrame:
                   CGRectMake(0, yPos, self.view.frame.size.width, textViewSize.height + 16)];
    articleBody.text = article.article;
    articleBody.font = [UIFont fontWithName:@"Palatino" size:15];
    articleBody.editable = NO;
    [scroll addSubview:articleBody];
    
    // Set the scroll view large enough to contain everything
    scroll.contentSize = CGSizeMake(self.view.frame.size.width, textViewSize.height + 16 + yPos);
}

// Set up the swipe right gesture (same as hitting back button)
- (void)handleSwipeRight {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
