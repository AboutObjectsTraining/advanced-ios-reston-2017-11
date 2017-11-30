#import <UIKit/UIKit.h>

@class RELBook;

@interface RELEditBookController : UITableViewController <UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) RELBook *book;

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *yearField;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

- (IBAction)doneSelectingAuthor:(UIStoryboardSegue *)segue;
- (IBAction)cancel:(UIStoryboardSegue *)segue;


// Keyboard Accessory

@property (strong, nonatomic) IBOutlet UIToolbar *inputAccessoryToolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *redoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *undoButton;

- (IBAction)redo:(UIBarButtonItem *)sender;
- (IBAction)undo:(UIBarButtonItem *)sender;

@end
