
#import "UIPageViewController+ReloadData.h"

@implementation UIPageViewController (ReloadData)

- (void) xcd_setViewControllers:(NSArray *)viewControllers direction:(UIPageViewControllerNavigationDirection)direction animated:(BOOL)animated completion:(void (^)(BOOL))completion
{
	void (^reloadData)(BOOL) = ^void(BOOL finished) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self setViewControllers:viewControllers direction:direction animated:NO completion:completion];
		});
	};
	
	[self setViewControllers:viewControllers direction:direction animated:animated completion:animated ? reloadData : completion];
}

@end