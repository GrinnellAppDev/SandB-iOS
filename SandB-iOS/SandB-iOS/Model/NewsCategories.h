
#import <Foundation/Foundation.h>

@interface NewsCategories : NSObject

@property (nonatomic, strong) NSMutableDictionary *categories;
@property (nonatomic, strong) NSMutableDictionary *categoriesByName;

+(NewsCategories *) sharedCategories;
-(void) categoriesWithData;

@end
