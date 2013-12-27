//
//  TestViewController.h
//  SandB-iOS
//
//  Created by Maijid Moujaled on 12/24/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface TestArticleViewController : UIViewController
@property (nonatomic, strong) Article *article;
@property (weak, nonatomic) IBOutlet UIScrollView *theScrollView;

@end
