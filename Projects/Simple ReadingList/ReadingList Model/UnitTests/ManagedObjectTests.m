#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>
#import "RELUtilities.h"

static NSString * const kStoreName = @"TestDB";
static NSString * const kModelName = @"ReadingList";

@interface NSManagedObject (UnitTestAdditions)

- (NSString *)title;
- (void)setTitle:(NSString *)newValue;

@end


@interface ManagedObjectTests : XCTestCase

@end


@implementation ManagedObjectTests
{
    NSManagedObjectContext *_context;
}

- (void)setUp
{
    [super setUp];
    putchar('\n');
    
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:kModelName ofType:@"momd" inDirectory:@"ReadingListBundle.bundle"];
    NSURL *modelURL = [NSURL fileURLWithPath:path];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType
                              configuration:nil
                                        URL:RELPathForDocument(kStoreName, @"sqlite")
                                    options:nil
                                      error:NULL];
    _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _context.persistentStoreCoordinator = coordinator;
}

- (void)tearDown
{
    putchar('\n');
    [super tearDown];
}

- (void)testPrimitivePropertyValue
{
    NSManagedObject *obj = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:_context];
    NSLog(@"%@", obj);
    [obj setPrimitiveValue:@"My Awesome Book" forKey:@"title"];
    NSLog(@"%@", obj);
    
    NSLog(@"Responds to accessor: %@", [obj respondsToSelector:@selector(title)] ? @"YES" : @"NO");
    NSLog(@"Primitive value: %@", [obj primitiveValueForKey:@"title"]);
    NSLog(@"Value returned by property accessor: %@", [obj title]);
    
    [obj setTitle:@"Yet Another, Even Cooler Title"];
    NSLog(@"Value after call to setTitle: %@", [obj title]);
}

@end
