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
        
       // NSLog(@"title: %@", _title);
       // NSLog(@"attachments: %@", attachments);
        
        if (attachments) {
            //todo - should loop.
            [attachments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
               _imageMediumURL =  obj[@"images"][@"medium"][@"url"];
               _imageLargeURL = obj[@"images"][@"large"][@"url"];
            }];
        }
        _author = [articleDictionary[@"custom_fields"][@"author"] firstObject];
        
        //Make Blurred Image.
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
             if (image)
             {
                 // do something with image
                 _blurredImage = [image applyLightEffect];
             }
         }];
    }
    return self;
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
