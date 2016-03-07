
#import <UIKit/UIPageViewController.h>

// Because UIPageViewController somehow "caches" its view controllers when you pass animated:YES and there is no "reloadData" method in UIPageViewControllerDataSource

@interface UIPageViewController (ReloadData)

- (void) xcd_setViewControllers:(NSArray *)viewControllers direction:(UIPageViewControllerNavigationDirection)direction animated:(BOOL)animated completion:(void (^)(BOOL))completion;

@end

