//
//  SuperViewController.h
//  SandB-iOS
//
//  Created by Colin Tremblay on 2/8/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBXML.h"

@interface SuperViewController : UIViewController {
    NSMutableArray *articleArray;
    TBXML *tbxml;
}

- (BOOL)networkCheck;
- (void)loadArticles:(NSString *)url;
NSString *ReplaceFirstNewLine(NSString *original);
NSString *ReplaceEmail(NSString *original);

@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, weak) IBOutlet UITableView *theTableView;

@end
