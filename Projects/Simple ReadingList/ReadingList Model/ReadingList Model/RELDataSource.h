#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

extern NSString * const RELFetchBatchSizeKey;
extern NSString * const RELiTunesSearchBatchSizeKey;

extern const NSUInteger RELFetchBatchSize;
extern const NSUInteger RELiTunesSearchBatchSize;

extern NSString * const RELReadingListCacheName;

extern NSString * const RELUseAutolayoutNameKey;
extern const BOOL RELUseAutolayout;


@interface RELDataSource : NSObject <UITableViewDataSource, NSFetchedResultsControllerDelegate>

// @name Configuration

/** Must be overridden by subclasses to provide an array of NSSortDescriptor objects. */
@property (nonatomic, readonly) NSArray *sortDescriptors;
/** May be overridden by subclasses to provide a cache name. Default is `nil`. */
@property (nonatomic, readonly) NSString *cacheName;
/** May be overridden by subclasses to provide an entity name. Default is "RELBook". */
@property (nonatomic, readonly) NSString *entityName;
/** May be overridden by subclasses to provide a section name keypath. Default is "author.name". */
@property (nonatomic, readonly) NSString * sectionNameKeyPath;
/** May be overridden by subclasses to provide an NSPredicate object. Default is `nil`. */
@property (nonatomic, readonly) NSPredicate *predicate;

/** May be overridden by subclasses to customize configuration of the fetchedResultsController. */
- (void)configureFetchedResultsController;
@property (strong, nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;

/** May be overridden by subclasses to customize configuration of the managedObjectContext. */
- (void)configureManagedObjectContext;
@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

- (NSString *)reuseIdentifierForCellAtIndexPath:(NSIndexPath *)indexPath;

// @name Accessing Objects
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

// @name Fetching
- (BOOL)fetch:(NSError * __autoreleasing *)error;
- (id)fetchObjectWithiTunesID:(NSNumber *)iTunesID entityName:(NSString *)entityName;
+ (id)fetchObjectWithiTunesID:(NSNumber *)iTunesID entityName:(NSString *)entityName managedObjectContext:(NSManagedObjectContext *)context;

// @name Saving
- (BOOL)save:(NSError * __autoreleasing *)error;

// @name Resetting the Context
/** Calls reset on the managed object context. */
- (void)reset;

// @name Getting the Table View
#pragma mark - IB Outlets
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
