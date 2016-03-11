
#import "Article.h"
#import "ArticleViewController.h"
#import "CategoryCell.h"
#import "ContentCell.h"
#import "DataModel.h"
#import "NewsCategories.h"
#import "ReadingOptions.h"
#import "TitleCell.h"
#import "UIImageView+WebCache.h"
#import "UIScrollView+APParallaxHeader.h"

#define CONTENT_WIDTH 306.0
#define IMAGE_HEADER_HEIGHT 400

@interface ArticleViewController ()

@end

@implementation ArticleViewController {
    CGFloat contentHeight;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // add parallax image
    if (self.article.image) {
       [self.tableView addParallaxWithImage:self.article.image
                                  andHeight:IMAGE_HEADER_HEIGHT];
    } else {
        [self.tableView addParallaxWithImage:[UIImage imageNamed:@"defaultImage"]
                                   andHeight:IMAGE_HEADER_HEIGHT];
    }
    
    self.savedToFavsView.alpha = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyAboutFavoriting) name:@"notifyAboutFavoriting" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyAboutUnfavoriting) name:@"notifyAboutUnfavoriting" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadContentForNewReadingOptions)
                                                 name:@"ReadingOptionsDismissed"
                                               object:nil];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    contentHeight = [self.article attrContentHeightForWidth:CONTENT_WIDTH];
}

#pragma mark - Table View Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *titleCellIdentifier = @"TitleCell";
    static NSString *contentCellIdentifier = @"ContentCell";
    static NSString *categoryCellIdentifier = @"CategoryCell";
    
    TitleCell *titleCell;
    ContentCell *contentCell;
    CategoryCell *categoryCell;
    
    if (indexPath.row == 0) {
        
        titleCell = [tableView dequeueReusableCellWithIdentifier:titleCellIdentifier forIndexPath:indexPath];
        
        //titleCell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleCell.titleLabel.numberOfLines = 0;
        [titleCell.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:20.0]];
        titleCell.titleLabel.text = self.article.title;
        
        return titleCell;
    
    } else if (indexPath.row == 1) {
        categoryCell = [tableView dequeueReusableCellWithIdentifier:categoryCellIdentifier forIndexPath:indexPath];
        
        categoryCell.categoryLabel.text = self.article.category;
        [categoryCell.categoryLabel setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:15]];
        
        int colorIndex = (int)[[[[NewsCategories sharedCategories] categories] objectForKey:@"names"] indexOfObject:self.article.category];
        
        [categoryCell.categoryLabel setTextColor:[[[[NewsCategories sharedCategories] categories] objectForKey:@"colors"] objectAtIndex:colorIndex]];
        
        categoryCell.byLabel.text = self.article.author;
        [categoryCell.byLabel setFont:[UIFont fontWithName:@"ProximaNova-Light" size:15]];
        
        return categoryCell;
   
    } else {
        contentCell = [tableView dequeueReusableCellWithIdentifier:contentCellIdentifier forIndexPath:indexPath];
        
        UITextView *contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(7, 20, CONTENT_WIDTH, contentHeight)];
        
        contentTextView.attributedText = self.article.attrContent;
        contentTextView.userInteractionEnabled = NO;
        contentTextView.selectable = NO;
        contentTextView.backgroundColor = [UIColor clearColor];
        
        // Remove existing contentTextView
        for (UIView *view in [contentCell.contentView subviews]) {
            [view removeFromSuperview];
        }
        
        [contentCell.contentView addSubview:contentTextView];
        
        return contentCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)path
{
    if (path.row == 2) {
        return contentHeight + 10;
    } else if (path.row == 0) {
        return 70.0f;
    } else {
        return 10.0f;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //CGFloat contentOffsetDifference = scrollView.contentOffset.y;
   // NSLog(@"our floattt: %f", contentOffsetDifference);
    
    if (scrollView.contentOffset.y > -69.0 ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ColorTopBar" object:nil];
    }
    
    else if (scrollView.contentOffset.y < -69.0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UncolorTopBar" object:nil];
    }
}

- (void)notifyAboutFavoriting
{
    self.savedLabel.text = @"Saved to favorites!";
    [UIView animateWithDuration:0.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.savedToFavsView.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         // Wait one second and then fade in the view
                         [UIView animateWithDuration:0.25
                                               delay: 0.6
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              self.savedToFavsView.alpha = 0;
                                          }
                                          completion:nil];
                     }];
}

- (void)notifyAboutUnfavoriting
{
    self.savedLabel.text = @"Removed from favorites!";
    //NSLog(@"unfavoriting!");
    [UIView animateWithDuration:0.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.savedToFavsView.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         // Wait one second and then fade in the view
                         [UIView animateWithDuration:0.25
                                               delay: 0.6
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              self.savedToFavsView.alpha = 0;
                                          }
                                          completion:nil];
                     }];
    
}

- (void)reloadContentForNewReadingOptions
{
    // update article's attrContent with possibly changed reading options
    [self.article formAttrContentWithReadingOptions:[ReadingOptions savedOptions]];
    
    [self.tableView reloadData];
}

@end
