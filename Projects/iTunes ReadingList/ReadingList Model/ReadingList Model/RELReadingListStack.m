#import "RELUtilities.h"
#import "RELReadingListStack.h"
#import "RELDataSource.h"

#import "RELAuthor.h"
#import "RELBook.h"

NSString * const RELReadingListModelNameKey = @"RELReadingListModelName";
NSString * const RELReadingListStoreNameKey = @"ReadingListStoreName";
NSString * const RELReadingListStoreType = @"sqlite";

@interface RELReadingListStack ()

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectContext *initialManagedObjectContext;

@end


@implementation RELReadingListStack

+ (instancetype)defaultStack
{
    static RELReadingListStack *_stack;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _stack = [[self alloc] init];
    });
    
    return _stack;
}

- (NSString *)modelName
{
    return [NSUserDefaults.standardUserDefaults objectForKey:RELReadingListModelNameKey];
}

- (NSString *)storeName
{
    return [NSUserDefaults.standardUserDefaults objectForKey:RELReadingListStoreNameKey];
}

- (NSURL *)initialStoreURL
{
    return RELPathForDocument(self.storeName, RELReadingListStoreType);
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    
    if (_persistentStoreCoordinator) return _persistentStoreCoordinator;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption : @YES,
                               NSInferMappingModelAutomaticallyOption : @YES };
    
    BOOL isNewStore = ![NSFileManager.defaultManager fileExistsAtPath:[NSString stringWithUTF8String:self.initialStoreURL.fileSystemRepresentation]];
    NSError *error;
    NSPersistentStore *store = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                         configuration:nil
                                                                                   URL:self.initialStoreURL
                                                                               options:options
                                                                                 error:&error];
    
    if (store == nil)
    {
        NSLog(@"WARNING: Unable to create store, error was %@", error);
    }
    else if (isNewStore && ![NSUserDefaults.standardUserDefaults boolForKey:@"isUnitTest"])
    {
        [self populateReadingList];
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) return _managedObjectModel;
    
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:self.modelName ofType:@"momd" inDirectory:@"ReadingListBundle.bundle"];
    NSURL *modelURL = [NSURL fileURLWithPath:path];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

- (NSManagedObjectContext *)initialManagedObjectContext
{
    if (_initialManagedObjectContext) return _initialManagedObjectContext;

    _initialManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _initialManagedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;

    return _initialManagedObjectContext;
}

/**
 Populates a Core Data store with data from a plist file.
*/
- (void)populateReadingList
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.persistentStoreCoordinator = self.persistentStoreCoordinator;
    
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"BooksAndAuthors" ofType:@"plist" inDirectory:@"ReadingListBundle.bundle"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSArray *authorDicts = dict[@"authors"];
    
    for (NSDictionary *authorDict in authorDicts)
    {
        RELAuthor *author = [RELAuthor insertInManagedObjectContext:context];
        [author setValuesForKeysWithDictionary:[authorDict dictionaryWithValuesForKeys:@[@"name"]]];
        
        for (NSDictionary *bookDict in authorDict[@"books"])
        {
            RELBook *book = [RELBook insertInManagedObjectContext:context];
            [book setValuesForKeysWithDictionary:bookDict];
            
            NSMutableOrderedSet *books = [author mutableOrderedSetValueForKey:@"books"];
            [books addObject:book];
        }
    }
    
    [context save:NULL];
}

@end
