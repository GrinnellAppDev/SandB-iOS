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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    articleTitle.text = article.title;
    CGSize textViewSize = [article.article sizeWithFont:[UIFont fontWithName:@"Palatino" size:16]
                                        constrainedToSize:CGSizeMake(self.view.frame.size.width,
                                                                     FLT_MAX)
                                          lineBreakMode:UILineBreakModeWordWrap];
    CGFloat yPos;

    if (article.image != nil) {
        yPos = 100;
        articleImage.image = article.image;
        articleImage.hidden = NO;
    }
    else {
        yPos = 5;
        articleImage.hidden = YES;
    }
    
    articleBody = [[UITextView alloc] initWithFrame:
                   CGRectMake(0, yPos, self.view.frame.size.width, textViewSize.height)];
    articleBody.text = article.article;
    articleBody.font = [UIFont fontWithName:@"Palatino" size:15];
    articleBody.editable = NO;
    [scroll addSubview:articleBody];
    scroll.contentSize = CGSizeMake(self.view.frame.size.width, textViewSize.height);
    
    UISwipeGestureRecognizer *swipeRight =
        [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(handleSwipeRight)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
    
    backgroundTitle.backgroundColor = [UIColor colorWithPatternImage:
                                       [UIImage imageNamed:@"SANDB.png"]];
}

- (void)handleSwipeRight {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
