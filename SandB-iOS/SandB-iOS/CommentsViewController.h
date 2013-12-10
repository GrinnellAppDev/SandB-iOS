//
//  CommentsViewController.h
//  SandB-iOS
//
//  Created by Colin Tremblay on 12/10/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TBXML.h>

@interface CommentsViewController : UIViewController {
    NSMutableArray *commentsArray;
    TBXML *tbxml;
}

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, weak) IBOutlet UITableView *theTableView;

@end
