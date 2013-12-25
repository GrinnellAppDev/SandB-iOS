//
//  DataModel.m
//  SandB-iOS
//
//  Created by Maijid Moujaled on 12/25/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel


+ (DataModel *)sharedModel {
    static DataModel *_sharedModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[DataModel alloc] init];
    });
    
    return _sharedModel;
}
- (id)init
{
    self  = [super init];
    if (self) {
        self.articles = [NSMutableArray new];
    }
    return self;
}


@end
