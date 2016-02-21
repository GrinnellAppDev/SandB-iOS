//
//  NewArticlesListTableViewController.h
//  SandB-iOS
//
//  Created by Lea Marolt on 4/6/14.
//  Copyright (c) 2014 Grinnell AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewArticlesListTableViewController : UITableViewController

// PROPERTIES
@property (nonatomic, strong) NSString *recievedCategory;

// METHODS
- (IBAction)refreshButtonPressed:(id)sender;

@end
