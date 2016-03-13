
#import <UIKit/UIKit.h>

@class Article;

@interface ArticlePageViewHolderController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *topBarView;
@property (strong, nonatomic) IBOutlet UIView *redSeparator;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *chatButton;
@property (strong, nonatomic) IBOutlet UIButton *starButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *editTextButton;

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSMutableArray *pageArticles;
@property (nonatomic, strong) NSString *recievedCategoryString;
@property (nonatomic, strong) Article *sentArticle;
@property (nonatomic) NSUInteger articleIndex;

- (IBAction)popViewController:(id)sender;
- (IBAction)favoriteButtonPressed:(id)sender;

@end
