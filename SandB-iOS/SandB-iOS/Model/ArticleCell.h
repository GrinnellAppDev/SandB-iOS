//
//  NewArticleCell.h
//  SandB-iOS
//
//  Created by Lea Marolt on 4/6/14.
//  Copyright (c) 2014 Grinnell AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *categoryIdentifier;
@property (strong, nonatomic) IBOutlet UILabel *articleTitle;
@property (strong, nonatomic) IBOutlet UILabel *articleDetails;
@property (nonatomic) BOOL read;

@end
