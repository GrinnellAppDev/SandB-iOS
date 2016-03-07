
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

@property (nonatomic, strong) IBOutlet UINavigationController *navController1;
@property (nonatomic, strong) IBOutlet UINavigationController *navController2;
@property (nonatomic, strong) IBOutlet UINavigationController *navController3;
@property (nonatomic, strong) IBOutlet UINavigationController *navController4;
@property (nonatomic, strong) IBOutlet UINavigationController *navController5;

@end
