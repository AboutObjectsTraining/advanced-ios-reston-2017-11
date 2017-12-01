#import <ReadingListModel/ReadingListModel.h>

#import "RELAppDelegate.h"
#import "RELAppDelegate+Appearance.h"

UIViewController *RELInitialViewController(NSString *storyboardName)
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:RELUseAutolayoutNameKey]) {
        storyboardName = [storyboardName stringByAppendingString:@"-Autolayout"];
    }
    
    return [[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateInitialViewController];
}


@implementation RELAppDelegate

/** Configures the app at launch time.
 
 Performs the following steps in the order in which they are listed below:
 
 1. Registers user defaults read from **AppDefaults.plist**
 2. Loads the root view controller for each of the tab bar controller's tabs
 3. Configures the appearance of:
 
   - The app's bars and bar items
   - The window's tint color
   - `UIButton` tint colors
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self registerAppDefaults];
    [self configureTabBar];
    [self configureAppearance];
    
    return YES;
}

- (void)registerAppDefaults
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppDefaults" ofType:@"plist"];
    NSMutableDictionary *defaultsDict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    if (defaultsDict[RELFetchBatchSizeKey] == nil)         defaultsDict[RELFetchBatchSizeKey] = @(RELFetchBatchSize);
    if (defaultsDict[RELiTunesSearchBatchSizeKey] == nil)  defaultsDict[RELiTunesSearchBatchSizeKey] = @(RELiTunesSearchBatchSize);
    if (defaultsDict[RELUseAutolayoutNameKey] == nil)      defaultsDict[RELUseAutolayoutNameKey] = @(RELUseAutolayout);
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsDict];
}

- (void)configureTabBar
{
    UIViewController *readingListController = RELInitialViewController(@"ReadingList");
    readingListController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:1];
    
    UIViewController *iTunesReadingListController = RELInitialViewController(@"iTunesReadingList");
    iTunesReadingListController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:2];
    
    UIViewController *searchController = RELInitialViewController(@"iTunesSearch");
    searchController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:3];
    
    UITabBarController *tabBarController = (UITabBarController *) self.window.rootViewController;
    tabBarController.viewControllers = @[readingListController, iTunesReadingListController, searchController];
}


#pragma mark - UIResponder

// NOTE: Discuss first responder and target-action dispatch mechanism.
//
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


@end
