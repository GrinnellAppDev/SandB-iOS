//
//  FeaturesViewController.m
//  SandB-iOS
//
//  Created by Colin Tremblay on 2/8/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import "FeaturesViewController.h"

@interface FeaturesViewController ()

@end

@implementation FeaturesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Features", @"Features");
        self.tabBarItem.image = [UIImage imageNamed:@"newspaper"];
    }
    return self;
}

- (void)viewDidLoad {
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(load:)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    [super loadArticles:@"http://www.thesandb.com/sections/features/feed"];
    [super viewDidLoad];
}

- (void)load:(id)sender {
    [super loadArticles:@"http://www.thesandb.com/sections/features/feed"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
