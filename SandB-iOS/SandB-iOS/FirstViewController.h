//
//  FirstViewController.h
//  SandB-iOS
//
//  Created by Lea Marolt on 1/25/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBXML.h"

@interface FirstViewController : UIViewController {
    NSMutableArray * articleArray;
    TBXML * tbxml;
}

- (void)loadArticles;
//For Custom Cell
@property (nonatomic, strong) NSString *cellIdentifier;

@end


