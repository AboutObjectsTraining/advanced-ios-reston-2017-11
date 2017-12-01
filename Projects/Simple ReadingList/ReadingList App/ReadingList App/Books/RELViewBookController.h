#import <UIKit/UIKit.h>

extern NSString * const RELSelectedBookKey;
extern NSString * const RELViewBookControllerDidSelectBookNotification;

@class RELBook;

@interface RELViewBookController : UITableViewController <UITextFieldDelegate>

@property (nonatomic) RELBook *book;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *genresLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBarButtonItem;

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;

@property (weak, nonatomic) IBOutlet UIImageView *addedCheckmark;
@property (weak, nonatomic) IBOutlet UIButton *addToReadingListButton;
- (IBAction)addToReadingList;

- (IBAction)cancelSelectingAuthor:(UIStoryboardSegue *)segue;

@end
