#import <ReadingListModel/ReadingListModel.h>

#import "RELAuthorDataSource.h"
#import "RELSelectAuthorController.h"
#import "UIStoryboardSegue+RELAdditions.h"

#import "RELAddAuthorController.h"

@interface RELSelectAuthorController ()

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) RELAuthorDataSource *dataSource;

@end


@implementation RELSelectAuthorController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource = [[RELAuthorDataSource alloc] init];
    self.dataSource.tableView = self.tableView;
    self.tableView.dataSource = self.dataSource;
    
    self.dataSource.fetchedResultsController = self.fetchedResultsController;
    self.fetchedResultsController.delegate = self.dataSource;
    
    [self fetch];
}

- (BOOL)fetch
{
    NSError *error;
    BOOL fetched = [self.fetchedResultsController performFetch:&error];
    
    if (!fetched)
    {
        DLOG(@"Unable to fetch books, error was: %@ %@", [error localizedDescription], [error localizedFailureReason]);
    }
    
    return fetched;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController) return _fetchedResultsController;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[RELAuthor entityName]];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:self.book.managedObjectContext
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:nil];
    NSError *error;
    BOOL fetched = [_fetchedResultsController performFetch:&error];
    if (!fetched) {
        DLOG(@"Unable to fetch authors. Error was %@", error.localizedDescription);
    }
    
    return _fetchedResultsController;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SelectAuthor"])
    {
        // For now, don't need to do anything here.
    }
    else if ([segue.identifier isEqualToString:@"AddAuthor"])
    {
        RELAddAuthorController *controller = [segue rel_realDestinationViewController];
        controller.managedObjectContext = self.book.managedObjectContext;
    }
}


#pragma mark - Actions and Unwind Segues

- (void)doneAddingAuthor:(UIStoryboardSegue *)segue
{
    RELAddAuthorController *controller = segue.sourceViewController;
    self.book.author = controller.author;
}

- (void)cancelAddingAuthor:(UIStoryboardSegue *)segue { }


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RELAuthor *author = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.book.author = author;
    
    [self.tableView reloadData];
    
    [self performSegueWithIdentifier:@"SelectAuthor" sender:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.accessoryType = [cell.textLabel.text isEqualToString:self.book.author.name] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

@end
