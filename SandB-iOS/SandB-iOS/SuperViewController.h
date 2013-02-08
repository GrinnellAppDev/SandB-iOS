//
//  SuperViewController.h
//  SandB-iOS
//
//  Created by Colin Tremblay on 2/8/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBXML.h"

@interface SuperViewController : UIViewController {
    NSMutableArray * articleArray;
    TBXML * tbxml;
}

- (void)loadArticles:(NSString *)url;
//For Custom Cell
@property (nonatomic, strong) NSString *cellIdentifier;

@end
