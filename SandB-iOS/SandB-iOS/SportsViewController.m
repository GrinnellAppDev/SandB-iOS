//
//  SportsViewController.m
//  SandB-iOS
//
//  Created by Lea Marolt on 1/25/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import "SportsViewController.h"

@interface SportsViewController ()

@end

@implementation SportsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Sports", @"Sports");
        self.tabBarItem.image = [UIImage imageNamed:@"basketball"];
    }
    return self;
}
							
- (void)viewDidLoad {
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(load:)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    [super loadArticles:@"http://www.thesandb.com/sections/sports/feed"];
    [super viewDidLoad];
}

- (void)load:(id)sender {
    [super loadArticles:@"http://www.thesandb.com/sections/sports/feed"];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
