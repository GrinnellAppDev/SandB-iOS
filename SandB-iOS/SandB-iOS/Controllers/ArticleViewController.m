
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
#define NAVBAR_COLOR_TRIGGER_OFFSET -69.0

#define NUMBER_ARTICLE_ROWS 3

#define TITLE_ROW_INDEX 0
#define CATEGORY_ROW_INDEX 1
#define CONTENT_ROW_INDEX 2

#define TITLE_ROW_HEIGHT 70.0f
#define CATEGORY_ROW_HEIGHT 10.0f
#define CONTENT_ROW_HEIGHT contentHeight + 10

@interface ArticleViewController ()

@end

@implementation ArticleViewController {
    CGFloat contentHeight; // used in CONTENT_ROW_HEIGHT macro
}

#pragma mark - View Lifecycle Methods

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
    return NUMBER_ARTICLE_ROWS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case TITLE_ROW_INDEX:
            return [self createTitleCellForTableView:tableView andIndexPath:indexPath];
            
        case CATEGORY_ROW_INDEX:
            return [self createCategoryCellForTableView:tableView andIndexPath:indexPath];
    
        case CONTENT_ROW_INDEX:
            return [self createContentCellForTableView:tableView andIndexPath:indexPath];
            
        default:        // Should never reach this
            return nil; // Just supresses compiler warnings
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case TITLE_ROW_INDEX:
            return TITLE_ROW_HEIGHT;
            
        case CATEGORY_ROW_INDEX:
            return CATEGORY_ROW_HEIGHT;
            
        case CONTENT_ROW_INDEX:
            return CONTENT_ROW_HEIGHT;
            
        default:         // Should never reach this
            return 0.0f; // Just supresses compiler warnings
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > NAVBAR_COLOR_TRIGGER_OFFSET) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ColorTopBar" object:nil];
    }
    
    else if (scrollView.contentOffset.y < NAVBAR_COLOR_TRIGGER_OFFSET) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UncolorTopBar" object:nil];
    }
}

#pragma mark - NotificationCenter Observers

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

#pragma mark - Table Cell Constructors

- (UITableViewCell *)createTitleCellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath
{
    static NSString *titleCellIdentifier = @"TitleCell";
    
    TitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:titleCellIdentifier forIndexPath:indexPath];
    
    //titleCell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleCell.titleLabel.numberOfLines = 0;
    [titleCell.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:20.0]];
    titleCell.titleLabel.text = self.article.title;
    
    return titleCell;
}

- (UITableViewCell *)createCategoryCellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath
{
    static NSString *categoryCellIdentifier = @"CategoryCell";
    
    CategoryCell *categoryCell = [tableView dequeueReusableCellWithIdentifier:categoryCellIdentifier forIndexPath:indexPath];
    
    categoryCell.categoryLabel.text = self.article.category;
    [categoryCell.categoryLabel setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:15]];
    
    int colorIndex = (int)[[[[NewsCategories sharedCategories] categories] objectForKey:@"names"] indexOfObject:self.article.category];
    
    [categoryCell.categoryLabel setTextColor:[[[[NewsCategories sharedCategories] categories] objectForKey:@"colors"] objectAtIndex:colorIndex]];
    
    categoryCell.byLabel.text = self.article.author;
    [categoryCell.byLabel setFont:[UIFont fontWithName:@"ProximaNova-Light" size:15]];
    
    return categoryCell;
}

- (UITableViewCell *)createContentCellForTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath
{
    static NSString *contentCellIdentifier = @"ContentCell";
    
    ContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:contentCellIdentifier forIndexPath:indexPath];
    
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

@end
