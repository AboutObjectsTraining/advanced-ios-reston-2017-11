#import <UIKit/UIKit.h>
#import <ReadingListModel/ReadingListModel.h>

@interface RELAddAuthorController : UITableViewController

@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) RELAuthor *author;

@property (weak, nonatomic) IBOutlet UITextField *nameField;

@end
