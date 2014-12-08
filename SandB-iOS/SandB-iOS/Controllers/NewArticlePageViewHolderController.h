//
//  NewArticlePageViewHolderController.h
//  SandB-iOS
//
//  Created by Lea Marolt on 4/6/14.
//  Copyright (c) 2014 Grinnell AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewArticleViewController.h"
#import "Article.h"

@interface NewArticlePageViewHolderController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSMutableArray *pageArticles;
@property (strong, nonatomic) IBOutlet UIView *topBarView;
- (IBAction)popViewController:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *redSeparator;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *chatButton;
@property (strong, nonatomic) IBOutlet UIButton *starButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *editTextButton;
@property (nonatomic) NSUInteger articleIndex;
@property (nonatomic, strong) NSString *recievedCategoryString;
@property (nonatomic, strong) Article *sentArticle;

// ACTIONS
- (IBAction)favoriteButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;

@end
