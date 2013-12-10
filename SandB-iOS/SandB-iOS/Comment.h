//
//  Comment.h
//  SandB-iOS
//
//  Created by Colin Tremblay on 12/10/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, strong) NSString *author;

@end

