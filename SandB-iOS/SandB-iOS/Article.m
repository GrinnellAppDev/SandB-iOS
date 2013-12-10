//
//  Article.m
//  SandB-iOS
//
//  Created by Lea Marolt on 2/3/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import "Article.h"

@implementation Article
@synthesize title, article, image, comments, commentsCount;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        title = [aDecoder decodeObjectForKey:@"title"];
        article = [aDecoder decodeObjectForKey:@"article"];
        comments = [aDecoder decodeObjectForKey:@"comments"];
        commentsCount = [aDecoder decodeIntForKey:@"commentsCount"];
        image = [UIImage imageWithData:[aDecoder decodeObjectForKey:@"image"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:article forKey:@"article"];
    [aCoder encodeObject:comments forKey:@"comments"];
    [aCoder encodeInt:commentsCount forKey:@"commentsCount"];
    NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
    [aCoder encodeObject:imgData forKey:@"image"];
}

@end
