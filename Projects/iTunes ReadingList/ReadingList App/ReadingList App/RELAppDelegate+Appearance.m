#import "UIColor+RELAdditions.h"
#import "RELAppDelegate+Appearance.h"

#import "RELReadingListController.h"

@implementation RELAppDelegate (Appearance)

// NOTE: Discuss UIAppearance.
//
- (void)configureAppearance
{
    self.window.tintColor = [UIColor rel_titleTextColor];
    
    [self configureButtonAppearance];
    [self configureBarAppearance];
}

- (void)configureButtonAppearance
{
    [UIButton appearance].tintColor = [UIColor rel_titleTextColor];
    [UIButton appearanceWhenContainedInInstancesOfClasses:@[UITableView.class]].tintColor = UIColor.rel_orangeButtonColor;
}

- (void)configureBarAppearance
{
    NSDictionary *barTitleTextAttributes = @{ NSFontAttributeName            : [UIFont fontWithName:@"Zapfino" size:15.0],
                                              NSForegroundColorAttributeName : [UIColor rel_titleTextColor] };
    
    NSDictionary *barItemTextAttributes = @{ NSFontAttributeName            : [UIFont fontWithName:@"Zapfino" size:11.0],
                                             NSForegroundColorAttributeName : [UIColor rel_titleTextColor] };
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:barItemTextAttributes forState:UIControlStateNormal];
    [[UINavigationBar appearance] setTitleTextAttributes:barTitleTextAttributes];
    
    UIColor *barColor = [UIColor rel_barColor];
    [UINavigationBar appearance].barTintColor = barColor;
    [UITabBar appearance].barTintColor = barColor;
}


@end
