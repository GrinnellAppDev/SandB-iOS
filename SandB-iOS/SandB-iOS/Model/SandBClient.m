//
//  SandBClient.m
//  SandB-iOS
//
//  Created by Maijid Moujaled on 12/24/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import "SandBClient.h"

@implementation SandBClient

+ (SandBClient *)sharedClient {
    static SandBClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:@"http://www.thesandb.com/api/"];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration]; 
        
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 *1024 * 1024
                                                          diskCapacity:50 *1024 * 1024
                                                              diskPath:nil];
        config.URLCache = cache;
        _sharedClient = [[SandBClient alloc] initWithBaseURL:baseURL sessionConfiguration:config];
    });
    
    return _sharedClient;
}
@end
