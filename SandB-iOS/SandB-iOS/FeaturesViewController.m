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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Features", @"Features");
        self.tabBarItem.image = [UIImage imageNamed:@"newspaper"];
    }
    return self;
}

- (void)viewDidLoad {
    UIButton *refresh = [[UIButton alloc] initWithFrame:CGRectMake(30, 30, 40, 40)];
    [refresh setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [refresh addTarget:self action:@selector(load:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *refreshButton =[[UIBarButtonItem alloc] initWithCustomView:refresh];
    [self.navigationItem setRightBarButtonItem:refreshButton animated:YES];
    
    [super loadArticles:@"http://www.thesandb.com/sections/features/feed"];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)load:(id)sender {
    [super loadArticles:@"http://www.thesandb.com/sections/features/feed"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
