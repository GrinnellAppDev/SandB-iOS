//
//  AppDelegate.h
//  SandB-iOS
//
//  Created by Lea Marolt on 1/25/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (nonatomic, strong) IBOutlet UINavigationController *navController1;
@property (nonatomic, strong) IBOutlet UINavigationController *navController2;
@property (nonatomic, strong) IBOutlet UINavigationController *navController3;
@property (nonatomic, strong) IBOutlet UINavigationController *navController4;

@end
