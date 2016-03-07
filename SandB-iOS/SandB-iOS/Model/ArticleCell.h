
#import <UIKit/UIKit.h>

@interface ArticleCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *categoryIdentifier;
@property (strong, nonatomic) IBOutlet UILabel *articleTitle;
@property (strong, nonatomic) IBOutlet UILabel *articleDetails;

@property (nonatomic) BOOL read;

@end
