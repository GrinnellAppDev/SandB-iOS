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

@property (nonatomic, strong) IBOutlet UIScrollView *scroll;
@property (nonatomic, strong) IBOutlet UILabel *articleTitle;
@property (nonatomic, strong) IBOutlet UIImageView *articleImage;
@property (nonatomic, strong) IBOutlet UILabel *articleBody;
@property (nonatomic, strong) Article *article;

- (void)commentsBtnTapped:(id)sender;

@end
