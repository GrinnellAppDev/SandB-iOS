
#import <UIKit/UIKit.h>

@interface ContentCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextView *contentTextView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@end
