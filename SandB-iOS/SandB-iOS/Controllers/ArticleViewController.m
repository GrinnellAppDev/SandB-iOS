//
//  ArticleViewController.m
//  SandB-iOS
//
//  Created by Maijid Moujaled on 12/23/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import "ArticleViewController.h"

@interface ArticleViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *blueLabel;
@end

@implementation ArticleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"Calledvwi");
    [self.titlelabel setTextColor:[UIColor whiteColor]];
    [self.titlelabel setShadowColor:[UIColor blackColor]];
    [self.titlelabel setShadowOffset:CGSizeMake(1, 1)];
    self.blueLabel.text = @"Hmm...";
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
