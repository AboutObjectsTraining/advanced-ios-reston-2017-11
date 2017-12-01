#import <UIKit/UIKit.h>
#import <ReadingListModel/ReadingListModel.h>

@interface RELAddBookController : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *yearField;
@property (weak, nonatomic) IBOutlet UITextField *authorField;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)cancelSelectingAuthor:(UIStoryboardSegue *)segue;

@end
