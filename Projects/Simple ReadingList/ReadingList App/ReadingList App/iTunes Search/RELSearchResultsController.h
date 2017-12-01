#import <UIKit/UIKit.h>

@class RELSearchResultsDataSource;

@interface RELSearchResultsController : UITableViewController 

@property (strong, nonatomic) NSString *searchTerms;

@property (strong, nonatomic) IBOutlet RELSearchResultsDataSource *dataSource;

@property (strong, nonatomic) IBOutlet UIView *activityBackgroundView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)cancel;

- (IBAction)doneViewingBook:(UIStoryboardSegue *)segue;

@end
