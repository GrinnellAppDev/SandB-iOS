//
//  NewsViewController.m
//  SandB-iOS
//
//  Created by Lea Marolt on 1/25/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import "NewsViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"News", @"News");
        self.tabBarItem.image = [UIImage imageNamed:@"newspaper"];
    }
    return self;
}

- (void)viewDidLoad {
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(load:)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    [super loadArticles:@"http://www.thesandb.com/feed"];
    [super viewDidLoad];
}

- (void)load:(id)sender {
    [super loadArticles:@"http://www.thesandb.com/feed"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end