#import <ReadingListModel/ReadingListModel.h>

#import "RELSearchResultsDataSource.h"
#import "RELSearchResultsCell.h"

NSString * const RELiTunesSearchConcurrentOperationCountKey = @"RELiTunesSearchConcurrentOperationCount";


@interface RELSearchResultsDataSource ()

@property (strong, nonatomic) NSOperationQueue *operationQueue;
@property (strong, nonatomic) NSPersistentStore *inMemoryStore;
@property (strong, nonatomic) NSPersistentStoreCoordinator *coordinator;

@end


@implementation RELSearchResultsDataSource

- (NSOperationQueue *)operationQueue
{
    if (_operationQueue) return _operationQueue;
    
    _operationQueue = [[NSOperationQueue alloc] init];
    _operationQueue.maxConcurrentOperationCount = [[NSUserDefaults standardUserDefaults] integerForKey:RELiTunesSearchConcurrentOperationCountKey];
    
    return _operationQueue;
}

- (NSString *)entityName         { return [RELBook entityName]; }
- (NSString *)sectionNameKeyPath { return @"author.name"; }
- (NSString *)reuseIdentifierForCellAtIndexPath:(NSIndexPath *)indexPath
{
    return @"iTunesBookSummary";
}


- (NSArray *)sortDescriptors
{
    return @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
}

- (void)configureInMemoryStore
{
    self.coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[RELReadingListStack defaultStack].managedObjectModel];
    
    NSError *e;
    self.inMemoryStore = [self.coordinator addPersistentStoreWithType:NSInMemoryStoreType
                          configuration:nil URL:nil options:nil error:&e];
    
    if (self.inMemoryStore == nil) {
        DLOG(@"Unable to add in memory store. Error was %@", e.localizedDescription);
    }
}

- (void)configureManagedObjectContext
{
    [self configureInMemoryStore];
    
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = self.coordinator;
}


- (void)configureFetchedResultsController
{
    [super configureFetchedResultsController];
    self.fetchedResultsController.delegate = self;
}


//
// ??? Bit of a hack. If context is empty, 'warm up' the fetched results controller by fetching nothing.
//
- (void)prepareToInsertManagedObjects
{
    if ([self.fetchedResultsController.managedObjectContext.registeredObjects count] == 0) {
        NSError *error;
        self.fetchedResultsController.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"0 = 0"];
        if (![self.fetchedResultsController performFetch:&error]) DLOG(@"Unable to fetch books, error was: %@", error);
        self.fetchedResultsController.fetchRequest.predicate = nil;
    }
}

- (void)insertObjectsFromDictionaries:(NSArray *)valueDictionaries
{
    [self prepareToInsertManagedObjects];
    
    NSManagedObjectContext *context = self.fetchedResultsController.managedObjectContext;
    NSMutableDictionary *authors = [NSMutableDictionary dictionary];
    
    for (NSDictionary *currDict in valueDictionaries)
    {
        NSString *authorName = currDict[RELiTunesAttributes.artistName];
        RELAuthor *author = authors[authorName];
        if (author == nil) {
            author = [RELAuthor insertInManagedObjectContext:context];
            [author setAttributeValuesWithiTunesDictionary:currDict];
            authors[authorName] = author;
        }
        
        RELBook *book = [RELBook insertInManagedObjectContext:context];
        [book setAttributeValuesWithiTunesDictionary:currDict];
        book.author = author;
        
        RELBookSynopsis *synopsis = [RELBookSynopsis insertInManagedObjectContext:context];
        [synopsis setAttributeValuesWithiTunesDictionary:currDict];
        book.synopsis = synopsis;
        
        RELBookCover *cover = [RELBookCover insertInManagedObjectContext:context];
        [cover setAttributeValuesWithiTunesDictionary:currDict];
        book.cover = cover;
    }
}

- (void)populateCell:(RELSearchResultsCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    RELBook *book = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.titleLabel.text = book.title;
    cell.yearLabel.text = book.year;
    cell.authorLabel.text = book.author.name;
    
    if (book.thumbnail60x60 != nil)
    {
        cell.authorImageView.image = book.thumbnail60x60;
    }
    else
    {
        [self.operationQueue addOperationWithBlock:^{
            NSURLSessionDataTask *task = [[NSURLSession sharedSession]
                                          dataTaskWithURL:book.thumbnail60x60URL
                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              [self setImageForBook:book withData:data response:(NSHTTPURLResponse *)response error:error];
                                          }];
            [task resume];
        }];
    }
}

- (void)setImageForBook:(RELBook *)book withData:(NSData *)data response:(NSHTTPURLResponse *)response error:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        book.thumbnail60x60 = response.statusCode == 200 ? [UIImage imageWithData:data] : [UIImage imageNamed:@"NoCover"];
    });
}

@end
