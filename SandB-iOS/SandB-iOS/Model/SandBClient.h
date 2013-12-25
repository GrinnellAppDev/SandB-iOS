//
//  SandBClient.h
//  SandB-iOS
//
//  Created by Maijid Moujaled on 12/24/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface SandBClient : AFHTTPSessionManager

+ (SandBClient *)sharedClient;

//- (NSURLD)getRecentPostWithCompletion:(void (^)(NSArray *results, NSError *error)completion);

@end
