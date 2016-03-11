
#import "Article.h"
#import "ReadingOptions.h"
#import "NSString+ISO8859Codes.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ImageEffects.h"

@implementation Article

- (instancetype)initWithArticleDictionary:(NSDictionary *)articleDictionary
{
    self = [super init];
    if (self) {
        
        
        // grab data from dictionary and set the properties
        self.title = [articleDictionary[@"title"] stringByDecodingXMLEntities];
        self.URL = articleDictionary[@"url"];
        self.content = articleDictionary[@"content"];
        self.content = [self.content stringByReplacingOccurrencesOfString:@"<div id=\"attachment_.*</div>" withString:@"" options:NSCaseInsensitiveSearch | NSRegularExpressionSearch range:NSMakeRange(0, [self.content length])];
        self.category = [articleDictionary[@"categories"] objectAtIndex:0][@"title"];
        self.articleId = [articleDictionary[@"id"] stringValue];
        
        // parse attachments, because they're in an array of dictionaries
        NSArray *attachments = articleDictionary[@"attachments"];
        NSDictionary *thumbnails = articleDictionary[@"thumbnail_images"];
        
        if (attachments) {
            
            //todo - should loop.
            [attachments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                if ([obj[@"images"] count] > 1) {
                    self.imageMediumURL = obj[@"images"][@"medium"][@"url"];
                    self.imageLargeURL = obj[@"images"][@"large"][@"url"];
                    self.imageSmallURL = obj[@"images"][@"thumbnail"][@"url"];
                }

            }];
        }
        
        if (thumbnails) {
            self.thumbnailImageURL = thumbnails[@"large"][@"url"];
        }
        
        self.author = [articleDictionary[@"custom_fields"][@"author"] firstObject];
        
        NSRange range = [self.author rangeOfString:@","];
        if (range.location != NSNotFound) {
            self.author = [self.author substringToIndex:range.location];
        }
        
        self.date = articleDictionary[@"date"];
        self.email = [articleDictionary[@"custom_fields"][@"author"] lastObject];
        
        // MAKE STRING INTO DATE
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *articleDate = [formatter dateFromString:self.date];
        
        NSDateFormatter *newFormatter = [[NSDateFormatter alloc] init];
        [newFormatter setDateFormat:@"dd MMM"];
        self.date = [newFormatter stringFromDate:articleDate];
        
        //This section is what we need to optimize on.
        //Blurring the images.
        
        [self formAttrContentWithReadingOptions:[ReadingOptions savedOptions]];
        
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        
        [manager downloadImageWithURL:[NSURL URLWithString:self.thumbnailImageURL]
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize){

         } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
             if (image)
             {
                 // do something with image
                 self.image = image;
             }
         }];
        
        
    }
    return self;
}

- (NSString *)description
{
    NSDictionary *desc = @{ @"title": self.title,
                            @"url": self.URL };
    
    return [NSString stringWithFormat:@"%@", desc ];
    
}

- (void)formAttrContentWithReadingOptions:(ReadingOptions *)options
{
    // Convert fontSize to percent between 100%-200%
    int percentageFontSize = (options.fontSize * 100) + 100;
    
    NSString * htmlAdditions = [NSString
                                stringWithFormat:@"<head><style type='text/css'>body{font-size: %d%%;font-family:'%@';color:#4A4A4A;}</style></head>", percentageFontSize, options.fontFamily];
    
    NSString *newContent =  [NSString stringWithFormat:@"<html>%@ %@</html>", htmlAdditions, self.content];
    
    NSError *error = nil;
    
    self.attrContent = [[NSMutableAttributedString alloc] initWithData:[newContent dataUsingEncoding:NSUTF32StringEncoding]
                                                                  options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                       documentAttributes:nil
                                                                    error:&error];
}

- (CGFloat)attrContentHeightForWidth:(CGFloat)width
{
    UITextView *textView = [[UITextView alloc] init];
    [textView setAttributedText:self.attrContent];
    
    CGSize size = [textView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    
    return size.height;
}

#pragma mark - Methods to determine equality

- (BOOL)isEqual:(id)other
{
    if (self == other)
        return YES;
    
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    
    return [self isEqualToArticle:other];
}

- (BOOL)isEqualToArticle:(Article *)anArticle
{
    if (self == anArticle)
        return YES;
    
    return ( [self.title isEqualToString:anArticle.title] &&
            [self.URL isEqualToString:anArticle.URL]);
}

//Hash function needed as helper for comparison method above.
- (NSUInteger)hash
{
    NSUInteger result = 1;
    NSUInteger prime = 31;
    
    // Use any object that already has a hash function (NSString)
    result = prime * result + [self.title hash];
    return result;
}

#pragma mark - Serializing and Deserializing
// cache

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.URL = [aDecoder decodeObjectForKey:@"URL"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.author = [aDecoder decodeObjectForKey:@"author"];
        self.category = [aDecoder decodeObjectForKey:@"category"];
        self.articleId = [aDecoder decodeObjectForKey:@"articleID"];
        self.imageSmallURL = [aDecoder decodeObjectForKey:@"imageSmallURL"];
        self.imageMediumURL = [aDecoder decodeObjectForKey:@"imageMediumURL"];
        self.imageLargeURL  = [aDecoder decodeObjectForKey:@"imageLargeURL"];
        //image = [UIImage imageWithData:[aDecoder decodeObjectForKey:@"image"]];
        
        // TODO: Save the images.
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.URL forKey:@"URL"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.author forKey:@"author"];
    [aCoder encodeObject:self.category forKey:@"category"];
    [aCoder encodeObject:self.articleId forKey:@"articleID"];
    [aCoder encodeObject:self.imageSmallURL forKey:@"imageSmallURL"];
    [aCoder encodeObject:self.imageMediumURL forKey:@"imageMediumURL"];
    [aCoder encodeObject:self.imageLargeURL forKey:@"imageLargeURL"];
}

@end
