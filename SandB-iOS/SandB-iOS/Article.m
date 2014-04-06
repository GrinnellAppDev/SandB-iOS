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
        
    
        _title =  articleDictionary[@"title"];
        
        _content = articleDictionary[@"content"];
        _category = articleDictionary[@"author"][@"name"];
        
        NSArray *attachments = articleDictionary[@"attachments"];
        
        NSLog(@"attachements: %@", attachments);
        
       // NSLog(@"title: %@", _title);
       // NSLog(@"attachments: %@", attachments);
        
        if (attachments) {
            //todo - should loop.
            [attachments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSLog(@"obj: %@", obj);
                
                if ([obj[@"images"] count] > 1) {
                    _imageMediumURL =  obj[@"images"][@"medium"][@"url"];
                    _imageLargeURL = obj[@"images"][@"large"][@"url"];
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
        _author = [articleDictionary[@"custom_fields"][@"author"] firstObject];
        
        //This section is what we need to optimize on.
        //Blurring the images.
        //And forming NSAttributedStrings from the article content.
        
        [self formAttributedString];
        
        
        /*
        dispatch_queue_t attrqueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        dispatch_async( attrqueue, ^{
            
            NSDictionary *options = @{
                                      NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                      };
            NSError *error = nil;
            _attrContent = [[NSMutableAttributedString alloc] initWithData:[_content dataUsingEncoding:NSUTF32StringEncoding]
                                                                   options:options documentAttributes:nil
                                                                     error:&error];
            
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"_attrContent: %@", _attrContent);
                    
                });
            } else {
                NSLog(@"WTF??"); 
            }
            
            
        });
         */
        
        
        
        /*
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadWithURL:[NSURL URLWithString:_imageMediumURL]
                         options:0
                        progress:^(NSUInteger receivedSize, long long expectedSize)
         {
             // progression tracking code
             // not needed
         }
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
         {
             NSLog(@"Donloading %@ image %@", _title, image);
             if (image)
             {
                 // do something with image
                 _blurredImage = [image applyLightEffect];
                 
             }
         }];
        */
        
        //Obviously this isn't right. We're doing it on the main thread. Need to figure out a way to blur this out. And then refresh the GlassScrollViews AFTER the image has been blurred. in order for this to work right...
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_imageMediumURL]]];
        
        UIColor *red = [UIColor colorWithRed:141.0f/255.0f green:29.0f/255.0f blue:41.0f/255.0f alpha:1.0f];
        _blurredImage = [image applyTintEffectWithColor:[UIColor blackColor]];
        

        

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

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        article = [aDecoder decodeObjectForKey:@"article"];
        comments = [aDecoder decodeObjectForKey:@"comments"];
        commentsCount = [aDecoder decodeIntForKey:@"commentsCount"];
        //image = [UIImage imageWithData:[aDecoder decodeObjectForKey:@"image"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:article forKey:@"article"];
    [aCoder encodeObject:comments forKey:@"comments"];
    [aCoder encodeInt:commentsCount forKey:@"commentsCount"];
   // NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
   // [aCoder encodeObject:imgData forKey:@"image"];
}

@end
