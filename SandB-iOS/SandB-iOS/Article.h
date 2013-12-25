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
@property (nonatomic, strong) NSURL *comments;
@property (nonatomic, assign) int commentsCount;


@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *category; //News, Opinion, Sports etc.
@property (nonatomic, strong) NSString *imageMediumURL;
@property (nonatomic, strong) NSString *imageLargeURL;
@property (nonatomic, strong) NSString *author;

- (instancetype)initWithArticleDictionary:(NSDictionary *)articleDictionary;

@end
