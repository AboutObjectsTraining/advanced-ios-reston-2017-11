#import <UIKit/UIKit.h>

@class RELBook;
@class RELViewBookController;

@interface RELSearchResultsDetailController : UIViewController

@property (nonatomic, strong) RELBook *book;
@property (readonly, nonatomic) RELViewBookController *viewBookController;

@property (weak, nonatomic) IBOutlet UIWebView *synopsisWebView;

@end
