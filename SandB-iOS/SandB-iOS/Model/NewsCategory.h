
#import <Foundation/Foundation.h>

@interface NewsCategory : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSNumber *idNum;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *highlightedColor;
@property (nonatomic, strong) UIColor *readBarColor;

-(id) categoryWithName:(NSString *) name andColor:(UIColor *) color andId:(NSNumber *) idNum andHighlightedColor:(UIColor *) higlighted andReadBarColor:(UIColor *)readBar;

@end
