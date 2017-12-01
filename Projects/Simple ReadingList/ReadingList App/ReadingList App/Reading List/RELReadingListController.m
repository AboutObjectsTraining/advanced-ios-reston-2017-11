#import <ReadingListModel/ReadingListModel.h>

#import "RELReadingListController.h"
#import "RELReadingListDataSource.h"
#import "UIStoryboardSegue+RELAdditions.h"

#import "RELAddBookController.h"
#import "RELViewBookController.h"


@implementation RELReadingListController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    [self.dataSource fetch:NULL];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier hasPrefix:@"Add"])
    {
        //Obtain a reference of the destination view controller
        RELAddBookController *addBookController = [segue rel_realDestinationViewController];
        addBookController.fetchedResultsController = self.dataSource.fetchedResultsController;
    }
    else if ([segue.identifier hasPrefix:@"View"])
    {
        RELViewBookController *viewBookController = segue.destinationViewController;
        NSIndexPath *selectedBook = self.tableView.indexPathForSelectedRow;
        RELBook *book = [self.dataSource objectAtIndexPath:selectedBook];
        [viewBookController setBook:book];
    }
}


#pragma mark - Unwind Segues

- (void)saveBookEdits:(UIStoryboardSegue * )segue { [self.dataSource save:NULL]; }
- (void)cancelBookEdits:(UIStoryboardSegue *)segue { }

- (void)addBook:(UIStoryboardSegue *)segue { [self.dataSource save:NULL]; }
- (void)cancelAddingBook:(UIStoryboardSegue *)segue { }


@end
