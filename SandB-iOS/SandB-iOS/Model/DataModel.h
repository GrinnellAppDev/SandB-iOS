//
//  DataModel.h
//  SandB-iOS
//
//  Created by Maijid Moujaled on 12/25/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Article.h"

@interface DataModel : NSObject

+ (DataModel *)sharedModel;
@property (nonatomic, strong) NSMutableArray *articles;
@end
