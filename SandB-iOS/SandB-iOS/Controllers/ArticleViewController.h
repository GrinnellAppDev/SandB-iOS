
#import <UIKit/UIKit.h>

@class Article;

@interface ArticleViewController : UIViewController 

@property (strong, nonatomic) IBOutlet UILabel *articleTitleLabel;
@property (strong, nonatomic) IBOutlet UITableView *theTableView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *savedToFavsView;
@property (strong, nonatomic) IBOutlet UIImageView *bigStar;
@property (strong, nonatomic) IBOutlet UILabel *savedLabel;

@property (strong, nonatomic) Article *article;
@property (nonatomic) NSUInteger pageIndex;

@end
