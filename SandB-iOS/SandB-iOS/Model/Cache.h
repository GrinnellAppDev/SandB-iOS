
#import <Foundation/Foundation.h>

@interface Cache : NSObject

+ (Cache *) sharedCacheModel;

- (void) archiveObject:(id)object toFileName:(NSString *)fileName;
- (id) loadArchivedObjectWithFileName:(NSString *)fileName;

@end
