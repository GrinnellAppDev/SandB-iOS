//
//  MenuViewController.h
//  SandB-iOS
//
//  Created by Lea Marolt on 4/6/14.
//  Copyright (c) 2014 Grinnell AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <StoreKit/StoreKit.h>

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, SKStoreProductViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *theTableView;
@property (strong, nonatomic) IBOutlet UIView *categoryIndicator;

@end
