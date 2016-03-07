
#import <UIKit/UIKit.h>

@class Article;

@interface TextOptionModalViewController : UIViewController

// PROPERTIES
@property (strong, nonatomic) IBOutlet UISlider *textSlider;
@property (strong, nonatomic) IBOutlet UIButton *sentinelFontButton;
@property (strong, nonatomic) IBOutlet UIButton *helveticaFontButton;
@property (strong, nonatomic) IBOutlet UIButton *ubuntuFontButton;

// METHODS
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)sentinelFontButtonPressed:(id)sender;
- (IBAction)helveticaFontButtonPressed:(id)sender;
- (IBAction)ubuntuFontButtonPressed:(id)sender;



@end
