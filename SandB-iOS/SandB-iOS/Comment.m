//
//  Comment.m
//  SandB-iOS
//
//  Created by Colin Tremblay on 12/10/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import "Comment.h"

@implementation Comment

@synthesize author, timestamp, text;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        author = [aDecoder decodeObjectForKey:@"author"];
        timestamp = [aDecoder decodeObjectForKey:@"time"];
        text = [aDecoder decodeObjectForKey:@"text"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:author forKey:@"author"];
    [aCoder encodeObject:timestamp forKey:@"time"];
    [aCoder encodeObject:text forKey:@"text"];
}

@end
