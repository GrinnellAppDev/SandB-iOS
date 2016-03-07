
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

- (void) archiveObject:(id)object toFileName:(NSString *)fileName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = paths[0];
    NSString *filePath = [cacheDirectory stringByAppendingPathComponent:fileName];
    [NSKeyedArchiver archiveRootObject:object toFile:filePath];
}

- (id) loadArchivedObjectWithFileName:(NSString *)fileName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = paths[0];
    NSString *filePath = [cacheDirectory stringByAppendingPathComponent:fileName];
    
    id cachedObject = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return cachedObject;
}

@end
