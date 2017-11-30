#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class RELReadingListDataSource;

@interface RELReadingListController : UITableViewController

@property (strong, nonatomic) IBOutlet RELReadingListDataSource *dataSource;

- (IBAction)saveBookEdits:(UIStoryboardSegue * )segue;
- (IBAction)cancelBookEdits:(UIStoryboardSegue *)segue;
- (IBAction)addBook:(UIStoryboardSegue *)segue;
- (IBAction)cancelAddingBook:(UIStoryboardSegue *)segue;

@end
