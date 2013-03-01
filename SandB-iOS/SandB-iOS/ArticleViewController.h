//
//  ArticleViewController.h
//  SandB-iOS
//
//  Created by Lea Marolt on 1/27/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface ArticleViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIScrollView *scroll;
@property (nonatomic, weak) IBOutlet UILabel *backgroundTitle;
@property (nonatomic, weak) IBOutlet UILabel *articleTitle;
@property (nonatomic, weak) IBOutlet UIImageView *articleImage;
@property (nonatomic, strong) IBOutlet UITextView *articleBody;
@property (nonatomic, strong) Article * article;

@end
