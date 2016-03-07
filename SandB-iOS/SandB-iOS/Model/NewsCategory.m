
#import "NewsCategory.h"

@implementation NewsCategory

-(id) categoryWithName:(NSString *) name andColor:(UIColor *) color andId:(NSNumber *) idNum andHighlightedColor:(UIColor *) higlighted andReadBarColor:(UIColor *)readBar{
    NewsCategory *cat = [[NewsCategory alloc] init];
    
    [cat setName:name];
    [cat setColor:color];
    [cat setIdNum:idNum];
    [cat setHighlightedColor:higlighted];
    [cat setReadBarColor:readBar];
    
    return cat;
}

@end
