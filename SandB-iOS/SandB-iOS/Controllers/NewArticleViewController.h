//
//  NewArticleViewController.h
//  SandB-iOS
//
//  Created by Lea Marolt on 4/6/14.
//  Copyright (c) 2014 Grinnell AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface NewArticleViewController : UIViewController 

@property (nonatomic) NSUInteger pageIndex;
@property (strong, nonatomic) IBOutlet UILabel *articleTitleLabel;
@property (nonatomic, strong) Article *article;
@property (strong, nonatomic) IBOutlet UITableView *theTableView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;


@end
