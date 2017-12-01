#import <ReadingListModel/ReadingListModel.h>

#import "NSString+RELAdditions.h"

#import "RELSearchResultsDetailController.h"
#import "RELViewBookController.h"


@implementation RELSearchResultsDetailController

- (RELViewBookController *)viewBookController
{
    return self.childViewControllers[0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewBookController.book = self.book;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *HTMLString = [NSString rel_HTMLDocumentStringWithContent:self.book.synopsis.text];
    [self.synopsisWebView loadHTMLString:HTMLString baseURL:[NSBundle mainBundle].bundleURL];
}

@end
