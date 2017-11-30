#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class RELBook;

@interface RELSelectAuthorController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) RELBook *book;

- (IBAction)doneAddingAuthor:(UIStoryboardSegue *)segue;
- (IBAction)cancelAddingAuthor:(UIStoryboardSegue *)segue;

@end
