//
//  NewArticleViewController.m
//  SandB-iOS
//
//  Created by Lea Marolt on 4/6/14.
//  Copyright (c) 2014 Grinnell AppDev. All rights reserved.
//

#import "NewArticleViewController.h"
#import "ContentCell.h"

@interface NewArticleViewController ()

@end

@implementation NewArticleViewController {
    CGFloat contentHeight;
    NSAttributedString *test;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.articleTitleLabel.text = self.article.title;
    self.articleContentTextView.text = self.article.content;
    test = [[NSAttributedString alloc] initWithString:self.article.content];
    contentHeight = [self textViewHeightForAttributedText:test andWidth:320.0] + 20;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table View Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *titleCellIdentifier = @"TitleCell";
    static NSString *contentCellIdentifier = @"ContentCell";
    
    UITableViewCell *titleCell;
    ContentCell *contentCell;
    
    if (indexPath.row == 0) {
        titleCell = [tableView dequeueReusableCellWithIdentifier:titleCellIdentifier forIndexPath:indexPath];
        titleCell.textLabel.text = self.article.title;
        return titleCell;
    }
    
    else //(indexPath.row == 1)
    {
        contentCell = [tableView dequeueReusableCellWithIdentifier:contentCellIdentifier forIndexPath:indexPath];
        contentCell.contentTextView.attributedText = test;
        
        return contentCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)path
{
    NSLog(@"stuff");
    if (path.row == 1) {
        return contentHeight;
    }
    
    else {
        return 40.0f;
    }
}

- (CGFloat)textViewHeightForAttributedText:(NSAttributedString *)text andWidth:(CGFloat)width
{
    UITextView *textView = [[UITextView alloc] init];
    [textView setAttributedText:text];
    CGSize size = [textView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}

@end
