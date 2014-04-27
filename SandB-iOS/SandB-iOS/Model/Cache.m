//
//  Cache.m
//  SandB-iOS
//
//  Created by Lea Marolt on 4/23/14.
//  Copyright (c) 2014 Grinnell AppDev. All rights reserved.
//

#import "Cache.h"

@implementation Cache

+ (Cache *)sharedCacheModel {
    static Cache *_sharedCacheModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCacheModel = [[Cache alloc] init];
    });
    
    return _sharedCacheModel;
}

+ (Cache *)sharedFavoritesModel {
    static Cache *_sharedFavoritesModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedFavoritesModel = [[Cache alloc] init];
    });
    
    return _sharedFavoritesModel;
}

- (id)init
{
    self  = [super init];
    if (self) {
        self.favoriteArticles = [NSMutableArray new];
    }
    return self;
}

- (void) archiveObject:(id)object toFileName:(NSString *)fileName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = paths[0];
    
    NSString *filePath = [cacheDirectory stringByAppendingPathComponent:fileName];
    
    [NSKeyedArchiver archiveRootObject:object toFile:filePath];
}

-(id) loadArchivedObjectWithFileName:(NSString *)fileName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = paths[0];
    NSString *filePath = [cacheDirectory stringByAppendingPathComponent:fileName];
    
    id cachedObject = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return cachedObject;
}

-(void) addToFavorites:(id)article {
    [self.favoriteArticles addObject:article];
}

@end
