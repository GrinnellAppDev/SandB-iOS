//
//  ArtsViewController.m
//  SandB-iOS
//
//  Created by Lea Marolt on 2/10/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import "ArtsViewController.h"

@interface ArtsViewController ()

@end

@implementation ArtsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Arts", @"Arts");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super loadArticles:@"http://www.thesandb.com/Arts/feed"];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
