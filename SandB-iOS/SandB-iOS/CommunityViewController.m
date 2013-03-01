//
//  CommunityViewController.m
//  SandB-iOS
//
//  Created by Lea Marolt on 2/17/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import "CommunityViewController.h"

@interface CommunityViewController ()

@end

@implementation CommunityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Community", @"Community");
        self.tabBarItem.image = [UIImage imageNamed:@"group"];
    }
    return self;
}

- (void)viewDidLoad {
    UIButton *refresh = [[UIButton alloc] initWithFrame:CGRectMake(30, 30, 40, 40)];
    [refresh setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [refresh addTarget:self action:@selector(load:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *refreshButton =[[UIBarButtonItem alloc] initWithCustomView:refresh];
    [self.navigationItem setRightBarButtonItem:refreshButton animated:YES];
    
    [super loadArticles:@"http://www.thesandb.com/sections/community/feed"];
    [super viewDidLoad];
}

- (void)load:(id)sender {
    [super loadArticles:@"http://www.thesandb.com/sections/community/feed"];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
