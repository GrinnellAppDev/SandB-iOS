//
//  Cache.h
//  SandB-iOS
//
//  Created by Lea Marolt on 4/23/14.
//  Copyright (c) 2014 Grinnell AppDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cache : NSObject

+ (Cache *) sharedCacheModel;
+ (Cache *) sharedFavoritesModel;

- (void) archiveObject:(id)object toFileName:(NSString *)fileName;
-(id) loadArchivedObjectWithFileName:(NSString *)fileName;
- (void) addToFavorites:(id)article;

@property (nonatomic, strong) NSMutableArray *favoriteArticles;

@end
