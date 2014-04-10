//
//  NewArticleViewController.m
//  SandB-iOS
//
//  Created by Lea Marolt on 4/6/14.
//  Copyright (c) 2014 Grinnell AppDev. All rights reserved.
//

#import "NewArticleViewController.h"
#import "ContentCell.h"
#import "UIScrollView+APParallaxHeader.h"
#import "UIImageView+WebCache.h"

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
    self.articleContentTextView.attributedText = self.article.attrContent;
    test = self.article.attrContent;
    
    NSLog(@"Thumbnail URL: %@", self.article.thumbnailImageURL);
    
    // add parallax image
    if (self.article.image) {
        [self.theTableView addParallaxWithImage:self.article.image andHeight:400];
    }
    else {
        [self.theTableView addParallaxWithImage:[UIImage imageNamed:@"defaultImage"] andHeight:400];
    }
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    [manager downloadWithURL:[NSURL URLWithString:self.article.thumbnailImageURL] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        // code
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
//        if (image) {
//            [self.theTableView addParallaxWithImage:image andHeight:400];
//        }
//    }];
    
//    [manager downloadWithURL:[NSURL URLWithString:self.article.thumbnailImageURL]
//                     options:0
//                    progress:^(NSUInteger receivedSize, long long expectedSize)
//     {
//         // progression tracking code
//         // not needed
//     }
//                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
//     {
//         NSLog(@"Donloading %@ image %@", _title, image);
//         if (image)
//         {
//             // do something with image
//             [self.theTableView addParallaxWithImage:image andHeight:400];
//             
//         }
//     }];
//
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    
//    CGSize size = self.articleContentTextView.contentSize;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    // change size of textview
    
//    CGFloat textViewWidth = self.articleContentTextView.frame.size.width;
//    CGSize newSize = [self.articleContentTextView sizeThatFits:CGSizeMake(textViewWidth, MAXFLOAT)];
//    CGRect newFrame = self.articleContentTextView.frame;
//    newFrame.size = CGSizeMake(fmaxf(newSize.width, textViewWidth), 500);
//    self.articleContentTextView.frame = newFrame;
    
    
    contentHeight = [self textViewHeightForAttributedText:test andWidth:320.0] + 20;

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
        //contentCell.contentTextView.attributedText = test;
        
        UITextView *contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(7, 0, 302, contentHeight)];
        contentTextView.attributedText = test;
        contentTextView.userInteractionEnabled = NO;
        contentTextView.selectable = NO;
        
        [contentCell.contentView addSubview:contentTextView];
        
        return contentCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)path
{
    NSLog(@"stuff");
    if (path.row == 1) {
        return contentHeight + 100;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetDifference = scrollView.contentOffset.y;
   // NSLog(@"our floattt: %f", contentOffsetDifference);
    
    if (scrollView.contentOffset.y > -69.0 ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ColorTopBar" object:nil];
    }
    
    else if (scrollView.contentOffset.y < -69.0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UncolorTopBar" object:nil];
    }
}

@end
