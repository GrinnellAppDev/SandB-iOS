//
//  Article.m
//  SandB-iOS
//
//  Created by Lea Marolt on 2/3/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import "Article.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ImageEffects.h"
#import "NSString+ISO8859Codes.h"

@implementation Article

@synthesize  article,  comments, commentsCount;

/*
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *category; //News, Opinion, Sports etc.
@property (nonatomic, strong) NSString *imageMediumURL;
@property (nonatomic, strong) NSString *imageLargeURL;
@property (nonatomic, strong) NSString *author;
*/

- (instancetype)initWithArticleDictionary:(NSDictionary *)articleDictionary
{
    self = [super init];
    if (self) {
        
        _title = [articleDictionary[@"title"] stringByDecodingXMLEntities];
        
        _URL = articleDictionary[@"url"];
        
        _content = articleDictionary[@"content"];
        
        _content = [_content stringByReplacingOccurrencesOfString:@"<div id=\"attachment_.*</div>" withString:@"" options:NSCaseInsensitiveSearch | NSRegularExpressionSearch range:NSMakeRange(0, [_content length])];
        
        
        _category = [articleDictionary[@"categories"] objectAtIndex:0][@"title"];
        
        NSArray *attachments = articleDictionary[@"attachments"];
        NSDictionary *thumbnails = articleDictionary[@"thumbnail_images"];
        
       // NSLog(@"title: %@", _title);
       // NSLog(@"attachments: %@", attachments);

        if (attachments) {

            //todo - should loop.
            [attachments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                if ([obj[@"images"] count] > 1) {
                    _imageMediumURL =  obj[@"images"][@"medium"][@"url"];
                    _imageLargeURL = obj[@"images"][@"large"][@"url"];
                    _imageSmallURL = obj[@"images"][@"thumbnail"][@"url"];
                }
                
                /*
                if (obj[@"images"][@"medium"][@"url"]) {
                    _imageMediumURL =  obj[@"images"][@"medium"][@"url"];
                }
                
                if (obj[@"images"][@"large"][@"url"]) {
                    _imageLargeURL = obj[@"images"][@"large"][@"url"];
                }
                 */
                
              // _imageMediumURL =  obj[@"images"][@"medium"][@"url"];
              // _imageLargeURL = obj[@"images"][@"large"][@"url"];
            }];
        }
        
        if (thumbnails) {
            self.thumbnailImageURL = thumbnails[@"large"][@"url"];
        }
        _author = [articleDictionary[@"custom_fields"][@"author"] firstObject];
        
        NSRange range = [_author rangeOfString:@","];
        if (range.location != NSNotFound) {
            _author = [_author substringToIndex:range.location];
        }
        
        _date = articleDictionary[@"date"];
        _email = [articleDictionary[@"custom_fields"][@"author"] lastObject];
        
        // MAKE STRING INTO DATE
        
        // TODO (DrJid): NSDateFormatter is expensive. Create one to be used for all instead of every single article. This would speed things up.
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *articleDate = [formatter dateFromString:_date];
        
        NSDateFormatter *newFormatter = [[NSDateFormatter alloc] init];
        [newFormatter setDateFormat:@"dd MMM"];
        _date = [newFormatter stringFromDate:articleDate];
        
        //This section is what we need to optimize on.
        //Blurring the images.
        //And forming NSAttributedStrings from the article content.
        
        [self formAttributedString];
        
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadWithURL:[NSURL URLWithString:self.thumbnailImageURL]
                         options:0
                        progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
             // progression tracking code
             // not needed
         }
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
         {
             if (image)
             {
                 // do something with image
                 _image = image;
                 
             }
         }];
        
        //Obviously this isn't right. We're doing it on the main thread. Need to figure out a way to blur this out. And then refresh the GlassScrollViews AFTER the image has been blurred. in order for this to work right...
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_imageMediumURL]]];
//        
//        UIColor *red = [UIColor colorWithRed:141.0f/255.0f green:29.0f/255.0f blue:41.0f/255.0f alpha:1.0f];
//        _blurredImage = [image applyTintEffectWithColor:[UIColor blackColor]];
        

        

    }
    return self;
}

- (void)formAttributedString
{
    //Increasing the font size via css - Did it this way because I didn't want to lose the formatting... Hmm..
    NSString *htmlOpen = @"<html>";
    NSString *htmlClose = @"</html>";
    NSString *htmlAdditions = @"<head><style type='text/css'> body{font-size: 150%;font-family:'Helvetica Neue';color:#4A4A4A;}</style></head>";
    NSString *newContent =  [NSString stringWithFormat:@"%@%@ %@%@",htmlOpen, htmlAdditions, _content, htmlClose];
    
    
    //NSLog(@"Forming attrString for %@", _title);
    NSError *error = nil;
    
    NSDictionary *options = @{
                              NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                              };

    
    _attrContent = [[NSMutableAttributedString alloc] initWithData:[newContent dataUsingEncoding:NSUTF32StringEncoding]
                                                           options:options documentAttributes:nil
                                                             error:&error];
    
    
    /*
     NSDictionary* attributes = @{
                                  NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]

     };
     
     
     [_attrContent addAttributes:attributes range:NSMakeRange(0, [_attrContent length])];
    */

}


// serializing & deserializing objects

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.URL = [aDecoder decodeObjectForKey:@"URL"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.author = [aDecoder decodeObjectForKey:@"author"];
        self.category = [aDecoder decodeObjectForKey:@"category"];
        //image = [UIImage imageWithData:[aDecoder decodeObjectForKey:@"image"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.URL forKey:@"URL"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.author forKey:@"author"];
    [aCoder encodeObject:self.category forKey:@"category"];
   // NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
   // [aCoder encodeObject:imgData forKey:@"image"];
}

@end
