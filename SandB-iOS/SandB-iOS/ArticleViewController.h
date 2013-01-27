//
//  ArticleViewController.h
//  SandB-iOS
//
//  Created by Lea Marolt on 1/27/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *articleTitle;
@property (nonatomic, weak) IBOutlet UITextView *article;

@end
