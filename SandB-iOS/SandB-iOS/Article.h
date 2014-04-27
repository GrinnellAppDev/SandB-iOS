//
//  Article.h
//  SandB-iOS
//
//  Created by Lea Marolt on 2/3/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *article;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSData *imageData; 
@property (nonatomic, strong) NSURL *comments;
@property (nonatomic, assign) int commentsCount;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *URL;
@property (nonatomic, strong) NSString *articleId;
@property (nonatomic) BOOL read;
@property (nonatomic) BOOL favorited;


@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *category; //News, Opinion, Sports etc.
@property (nonatomic, strong) NSString *imageMediumURL;
@property (nonatomic, strong) NSString *imageLargeURL;
@property (nonatomic, strong) NSString *imageSmallURL;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSMutableAttributedString *attrContent; 

@property (nonatomic, strong) UIImage *blurredImage;

@property (nonatomic, strong) NSString *thumbnailImageURL;

- (instancetype)initWithArticleDictionary:(NSDictionary *)articleDictionary;

@end
