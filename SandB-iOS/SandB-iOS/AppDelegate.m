//
//  AppDelegate.m
//  SandB-iOS
//
//  Created by Lea Marolt on 1/25/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import "AppDelegate.h"

#import "SandBClient.h"
#import "AFNetworkActivityIndicatorManager.h"
#import <Crashlytics/Crashlytics.h>

@implementation AppDelegate
@synthesize window, tabBarController, navController1, navController2, navController3, navController4, navController5;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

    [Crashlytics startWithAPIKey:@"45894d9e8a6bc3b8513651d6de36159e2c836e51"];
    //[Crashlytics sharedInstance].debugMode = YES;
    
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:140.0/255 green:29.0/255 blue:41.0/255 alpha:1.0]];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"Helvetica Neue" size:23.0], NSFontAttributeName, nil]];

    
    /*
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    NewsViewController *viewController1 = [[NewsViewController alloc] initWithNibName:@"NewsViewController"
                                                            bundle:nil];
    navController1 = [[UINavigationController alloc] initWithRootViewController:viewController1];
    navController1.navigationBar.translucent = NO;
    
    SportsViewController *viewController2 = [[SportsViewController alloc] initWithNibName:@"SportsViewController"
                                                             bundle:nil];
    navController2 = [[UINavigationController alloc] initWithRootViewController:viewController2];
    navController2.navigationBar.translucent = NO;
    
    CommunityViewController *viewController3 = [[CommunityViewController alloc] initWithNibName:@"CommunityViewController"
                                                                bundle:nil];
    navController3 = [[UINavigationController alloc] initWithRootViewController:viewController3];
    navController3.navigationBar.translucent = NO;
    
    OpinionViewController *viewController4 = [[OpinionViewController alloc] initWithNibName:@"OpinionViewController"
                                                              bundle:nil];
    navController4 = [[UINavigationController alloc] initWithRootViewController:viewController4];
    navController4.navigationBar.translucent = NO;
    
    ArtsViewController *viewController5 = [[ArtsViewController alloc] initWithNibName:@"ArtsViewController"
                                                           bundle:nil];
    navController5 = [[UINavigationController alloc] initWithRootViewController:viewController5];
    navController5.navigationBar.translucent = NO;
    
    self.tabBarController = [[UITabBarController alloc] init];
    NSArray *viewsArray = [[NSArray alloc] initWithObjects:navController1, navController2, navController3, navController4, navController5, nil];
    self.tabBarController.viewControllers = viewsArray;
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];

    // Make things red
    self.window.tintColor = [UIColor colorWithRed:142.0f/255.0f green:42.0f/255.0f blue:29.0f/255.0f alpha:1.0f];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarStyle:UIBarStyleBlackOpaque];
    self.tabBarController.tabBar.translucent = NO;
    */
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
 // Optional UITabBarControllerDelegate method.
 - (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
 {
 }
 */

/*
 // Optional UITabBarControllerDelegate method.
 - (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
 {
 }
 */

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window

{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return UIInterfaceOrientationMaskAll;
    else  /* iphone */
        return UIInterfaceOrientationMaskPortrait;
}

@end
