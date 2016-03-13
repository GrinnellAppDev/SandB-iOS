
#import <Crashlytics/Crashlytics.h>

#import "AFNetworkActivityIndicatorManager.h"
#import "AppDelegate.h"
#import "SandBClient.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    [self setupAPIKeys];
    [self setupNavBarAppearance];
    [self setupReadingOptionsDefaults];
    
    return YES;
}


- (UIInterfaceOrientationMask)application:(UIApplication *)application
    supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAll;
    } else {
        // Allow only portrait on iPhone
        return UIInterfaceOrientationMaskPortrait;
    }
}

#pragma mark - Helper Methods

- (void)setupAPIKeys {
    NSString *strings_private = [[NSBundle mainBundle] pathForResource:@"strings_private"
                                                                ofType:@"strings"];
    NSDictionary *keysDict = [NSDictionary dictionaryWithContentsOfFile:strings_private];
    
    [Crashlytics startWithAPIKey:[keysDict objectForKey:@"CrashlyticsAPIKey"]];
}

- (void)setupNavBarAppearance {
    [[UINavigationBar appearance]
        setBarTintColor:[UIColor colorWithRed:140.0/255.0
                                        green:29.0/255.0
                                         blue:41.0/255.0
                                        alpha:1.0]];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    
    [[UINavigationBar appearance]
        setTitleTextAttributes:@{
       NSForegroundColorAttributeName : [UIColor whiteColor],
       NSShadowAttributeName : shadow,
       NSFontAttributeName : [UIFont fontWithName:@"ProximaNova-Regular" size:23.0]
    }];
}

- (void)setupReadingOptionsDefaults {
    NSString *defaultReadingOptionsPath = [[NSBundle mainBundle]
                                               pathForResource:@"DefaultReadingOptions"
                                                        ofType:@"plist"];
    
    NSDictionary *defaultReadingOptions = [NSDictionary dictionaryWithContentsOfFile:defaultReadingOptionsPath];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultReadingOptions];
}

@end
