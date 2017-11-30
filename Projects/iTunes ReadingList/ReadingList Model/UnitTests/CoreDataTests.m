#import <XCTest/XCTest.h>
#import "ReadingListModel/ReadingListModel.h"

NSString * const RELAuthorNameAttributeName = @"name";
NSString * const RELAuthorEntityName = @"Author";

@interface CoreDataTests : XCTestCase

@end


@implementation CoreDataTests
{
    NSManagedObjectContext *_managedObjectContext;
}


+ (void)initialize
{
    // Override defaults.
    [[NSUserDefaults standardUserDefaults] setObject:@"UnitTestStore" forKey:@"ReadingListStoreName"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isUnitTest"];
}

- (void)setUp
{
    [super setUp];
    putchar('\n');
    
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.persistentStoreCoordinator = [RELReadingListStack defaultStack].persistentStoreCoordinator;
}

- (void)tearDown
{
    // Nuke the store coordinator.
    [[RELReadingListStack defaultStack] setValue:nil forKey:@"_persistentStoreCoordinator"];
    
    NSURL *storeURL = [RELReadingListStack defaultStack].initialStoreURL;
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:NULL];
    
    putchar('\n');
    [super tearDown];
}

- (void)testInsertMO
{
    RELAuthor *newAuthor = [NSEntityDescription insertNewObjectForEntityForName:RELAuthorEntityName inManagedObjectContext:_managedObjectContext];
    NSSet *registeredObjects = _managedObjectContext.registeredObjects;
    
    XCTAssertTrue([registeredObjects containsObject:newAuthor], @"");
}

- (void)testDeleteAuthorMO
{
    RELAuthor *newAuthor = [NSEntityDescription insertNewObjectForEntityForName:RELAuthorEntityName inManagedObjectContext:_managedObjectContext];
    [_managedObjectContext deleteObject:newAuthor];
    
    BOOL isDeleted = newAuthor.isDeleted;
    
    XCTAssertTrue(isDeleted, @"");
    
    //The actual count here should be 1 because save is never called.
    NSUInteger actualCount = _managedObjectContext.registeredObjects.count;
    NSUInteger expectedCount = 1;
    
    XCTAssertEqual(actualCount, expectedCount, @"");
    
    [_managedObjectContext save:NULL];
    
    //The actual count here should be 0 after save is called.
    actualCount = _managedObjectContext.registeredObjects.count;
    expectedCount = 0;
    
    XCTAssertEqual(actualCount, expectedCount, @"");
}

- (void)testFetchRequest
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[RELAuthor entityName]];
    
    NSUInteger actualCount = [_managedObjectContext countForFetchRequest:fetchRequest error:NULL];
    NSUInteger expectedCount = 0;
    
    XCTAssertEqual(actualCount, expectedCount, @"");
}

- (void)testInsertAndFetch
{
    NSString *attributeValue = @"Test Specific Author";
    
    RELAuthor *newAuthor = [NSEntityDescription insertNewObjectForEntityForName:RELAuthorEntityName
                                                         inManagedObjectContext:_managedObjectContext];
    [newAuthor setValue:attributeValue forKey:RELAuthorNameAttributeName];
    
    [_managedObjectContext save:NULL];
    [_managedObjectContext reset];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:RELAuthorEntityName];
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"%K = %@", RELAuthorNameAttributeName, attributeValue];
    fetchRequest.predicate = searchPredicate;
    
    NSUInteger actualCount = [_managedObjectContext countForFetchRequest:fetchRequest error:NULL];
    NSUInteger expectedCount = 1;
    
    XCTAssertEqual(actualCount, expectedCount, @"");
}

- (void)testDelete
{
    RELAuthor *author = [RELAuthor insertInManagedObjectContext:_managedObjectContext];
    RELBook *book = [RELBook insertInManagedObjectContext:_managedObjectContext];
    book.title = @"Woohoo!";
    book.author = author;
    
//    NSError *error;
//    if (![_managedObjectContext save:&error]) NSLog(@"%@", error);
//    
//    [_managedObjectContext reset];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[RELBook entityName]];
//    NSArray *books = [_managedObjectContext executeFetchRequest:fetchRequest error:NULL];
//    RELBook *fetchedBook = books[0];
//    RELAuthor *fetchedAuthor = book.author;
    
    NSLog(@"Registered objects: %ld", _managedObjectContext.registeredObjects.count);
    NSLog(@"Deleted objects: %ld", _managedObjectContext.deletedObjects.count);
    XCTAssertEqual(_managedObjectContext.registeredObjects.count, 2, @"");
    XCTAssertEqual(_managedObjectContext.deletedObjects.count, 0, @"");

    [_managedObjectContext deleteObject:author];
    [_managedObjectContext deleteObject:book];
    
    NSLog(@"Registered objects: %ld", _managedObjectContext.registeredObjects.count);
    NSLog(@"Deleted objects: %ld", _managedObjectContext.deletedObjects.count);
    XCTAssertEqual(_managedObjectContext.registeredObjects.count, 2, @"");
    XCTAssertEqual(_managedObjectContext.deletedObjects.count, 2, @"");
    
    [_managedObjectContext save:NULL];
    
    NSLog(@"Registered objects: %ld", _managedObjectContext.registeredObjects.count);
    NSLog(@"Deleted objects: %ld", _managedObjectContext.deletedObjects.count);
    XCTAssertEqual(_managedObjectContext.registeredObjects.count, 0, @"");
    XCTAssertEqual(_managedObjectContext.deletedObjects.count, 0, @"");
}

- (void)testOptimisticLockingOnPropertyChange
{
    NSManagedObjectContext *otherContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    otherContext.persistentStoreCoordinator = [RELReadingListStack defaultStack].persistentStoreCoordinator;
    
    RELAuthor *author = [RELAuthor insertInManagedObjectContext:_managedObjectContext];
    author.name = @"Author Name 1";
    [_managedObjectContext save:NULL];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[RELAuthor entityName]];
    NSArray *fetchedObjs = [otherContext executeFetchRequest:fetchRequest error:NULL];
    RELAuthor *fetchedAuthor = fetchedObjs.firstObject;
    NSLog(@"%@", fetchedAuthor.name);
    
    // Enable conflict detection. (Default behavior is to merge changes.)
    [otherContext detectConflictsForObject:fetchedAuthor];
    
    author.name = @"Author Name 2";
    author.iTunesID = @1;
    [_managedObjectContext save:NULL];
    
    fetchedAuthor.name = @"Author Name 3";
    NSError *error;
    BOOL saved = [otherContext save:&error];
    XCTAssertFalse(saved, @"");
    
    if (!saved) NSLog(@"Error: %@", error);
    NSLog(@"%@", fetchedAuthor);
}

- (void)testOptimisticLockingOnDeletion
{
    NSManagedObjectContext *otherContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    otherContext.persistentStoreCoordinator = [RELReadingListStack defaultStack].persistentStoreCoordinator;
    
    RELAuthor *author = [RELAuthor insertInManagedObjectContext:_managedObjectContext];
    author.name = @"Author Name 1";
    [_managedObjectContext save:NULL];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[RELAuthor entityName]];
    NSArray *fetchedObjs = [otherContext executeFetchRequest:fetchRequest error:NULL];
    RELAuthor *fetchedAuthor = fetchedObjs.firstObject;
    NSLog(@"%@", fetchedAuthor.name);
    
    // Enable conflict detection. (Default behavior is to merge changes.)
    [otherContext detectConflictsForObject:fetchedAuthor];
    
    [_managedObjectContext deleteObject:author];
    [_managedObjectContext save:NULL];
    
    NSError *error;
    BOOL saved = [otherContext save:&error];
    XCTAssertFalse(saved, @"");
    
    if (!saved) NSLog(@"Error: %@", error);
    NSLog(@"%@", fetchedAuthor);
}

- (void)testFault
{
    RELAuthor *newAuthor = [NSEntityDescription insertNewObjectForEntityForName:RELAuthorEntityName
                                                         inManagedObjectContext:_managedObjectContext];
    newAuthor.name = @"Test Author";
    NSLog(@"New Author: %@", newAuthor);
    
    [_managedObjectContext save:NULL];
    [_managedObjectContext reset];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:RELAuthorEntityName];
    NSArray *results = [_managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    RELAuthor *fetchedAuthor = results.firstObject;
    NSLog(@"Faulted Author: %@", fetchedAuthor);
    XCTAssertTrue(fetchedAuthor.isFault, @"");
    
    NSLog(@"%@", fetchedAuthor.name);
    NSLog(@"Fetched Author: %@", fetchedAuthor);
    XCTAssertFalse(fetchedAuthor.isFault, @"");
}

- (void)testAuthorObjectID
{
    RELAuthor *newAuthor = [NSEntityDescription insertNewObjectForEntityForName:RELAuthorEntityName
                                                         inManagedObjectContext:_managedObjectContext];
    NSManagedObjectID *tempID = [newAuthor objectID];
    XCTAssertTrue([tempID isTemporaryID], @"");
    
    [_managedObjectContext save:NULL];
    
    NSManagedObjectID *authorID = [newAuthor objectID];
    XCTAssertFalse([authorID isTemporaryID], @"");
    [_managedObjectContext reset];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:RELAuthorEntityName];
    NSArray *results = [_managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    
    NSManagedObjectID *fetchedID = [results[0] objectID];
    XCTAssertEqualObjects(fetchedID.URIRepresentation.host, authorID.URIRepresentation.host, @"");
}


@end
