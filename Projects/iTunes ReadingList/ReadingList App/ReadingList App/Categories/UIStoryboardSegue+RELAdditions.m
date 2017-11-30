#import "UIStoryboardSegue+RELAdditions.h"

@implementation UIStoryboardSegue (RELAdditions)

/**
Convenience method for accessing a destination view controller embedded in a navigation controller.
@return The destination view controller.
*/
- (id)rel_realDestinationViewController
{
    if ([self.destinationViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navController = self.destinationViewController;
        return navController.viewControllers[0];
    }
    
    return self.destinationViewController;
}

@end
