#import "RELDataSource.h"
#import "RELReadingListStack.h"

#import "RELBook.h"

NSString * const RELFetchBatchSizeKey = @"RELFetchBatchSize";
NSString * const RELiTunesSearchBatchSizeKey = @"RELiTunesSearchBatchSize";
const NSUInteger RELFetchBatchSize = 20;
const NSUInteger RELiTunesSearchBatchSize = 20;

NSString * const RELReadingListCacheName = @"ReadingListCache";

NSString * const RELUseAutolayoutNameKey = @"RELUseAutolayout";
const BOOL RELUseAutolayout = NO;

@interface RELDataSource ()
@property (strong, nonatomic, readwrite) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic, readwrite) NSManagedObjectContext *managedObjectContext;
@end

@implementation RELDataSource

- (NSString *)cacheName          { return nil; }
- (NSString *)entityName         { return nil; }
- (NSString *)sectionNameKeyPath { return nil; }
- (NSPredicate *)predicate       { return nil; }
- (NSArray *)sortDescriptors     { return nil; }

- (void)configureManagedObjectContext
{
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = [RELReadingListStack defaultStack].persistentStoreCoordinator;
}

- (void)configureFetchedResultsController
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:self.entityName];
    fetchRequest.sortDescriptors = self.sortDescriptors;
    fetchRequest.fetchBatchSize = [[NSUserDefaults standardUserDefaults] integerForKey:RELFetchBatchSizeKey];
    fetchRequest.predicate = self.predicate;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:self.managedObjectContext
                                                                      sectionNameKeyPath:self.sectionNameKeyPath
                                                                               cacheName:RELReadingListCacheName];
    self.fetchedResultsController.delegate = self;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController == nil) [self configureFetchedResultsController];
    return _fetchedResultsController;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext == nil) [self configureManagedObjectContext];
    return _managedObjectContext;
}

/**
 * Overridden by subclasses to return a reuse identifier for the cell prototype
 * that corresponds to `indexPath`.
 * @param indexPath The index path for the current row.
 */
- (NSString *)reuseIdentifierForCellAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Cell";
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (void)populateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    DLOG(@"WARNING: Cell not populated at index path %@", indexPath);
}


/**
 * Uses the data source's built-in fetchedResultsController to perform a fetch.
 * @param error If an error occurs, upon return contains an instance of NSError describing the error.
 * @return `YES` if the attempted fetch was successful; otherwise `NO`.
 */
- (BOOL)fetch:(NSError *__autoreleasing *)error
{
    NSError *e;
    BOOL fetched = [self.fetchedResultsController performFetch:&e];
    
    if (!fetched) {
        DLOG(@"Unable to fetch.\nError was: %@ %@", e.localizedDescription, e.localizedFailureReason);
        *error = e;
    }
    
    return fetched;
}

+ (id)fetchObjectWithiTunesID:(NSNumber *)iTunesID entityName:(NSString *)entityName managedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"iTunesID" ascending:YES]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"iTunesID = %@", iTunesID];
    
    NSError *e;
    NSArray *fetchedObjs = [context executeFetchRequest:fetchRequest error:&e];
    
    if (fetchedObjs == nil) DLOG(@"Unable to fetch with request %@. Error was %@ %@", fetchRequest, e.localizedDescription, e.localizedFailureReason);
    if (fetchedObjs.count > 1 && iTunesID.intValue > 0) DLOG(@"WARNING: Duplicate objects found:\n%@", fetchedObjs);
    
    return fetchedObjs.firstObject;
}


- (id)fetchObjectWithiTunesID:(NSNumber *)iTunesID entityName:(NSString *)entityName
{
    return [[self class] fetchObjectWithiTunesID:iTunesID entityName:entityName managedObjectContext:self.managedObjectContext];
}

- (BOOL)save:(NSError * __autoreleasing *)error
{
    BOOL saved = YES;
    
    if (self.managedObjectContext.hasChanges) {
        NSError *e;
        saved = [self.managedObjectContext save:&e];
        
        if (!saved) {
            DLOG(@"Unable to save.\nError was %@ %@", e.localizedDescription, e.localizedFailureReason);
            *error = e;
        }
    }
    
    return saved;
}

- (void)reset
{
    [self.managedObjectContext reset];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
        default: break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self populateCell:[self.tableView cellForRowAtIndexPath:indexPath]
                   atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    return [self.fetchedResultsController.sections[section] name];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> info = self.fetchedResultsController.sections[section];
    return info.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [self reuseIdentifierForCellAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    [self populateCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        id obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.fetchedResultsController.managedObjectContext deleteObject:obj];
    }
    
    [self save:nil];
}

@end
