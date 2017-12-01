#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>

#import "RELUtilities.h"

static NSString * const kStoreName = @"TestDB";
static NSString * const kModelName = @"ReadingList";

@interface CoreDataStackTests : XCTestCase

@end


@implementation CoreDataStackTests

- (void)setUp
{
    [super setUp];
    putchar('\n');
}

- (void)tearDown
{
    putchar('\n');
    [super tearDown];
}

- (void)testCreateModel
{
    NSString *modelName = kModelName;
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:modelName ofType:@"momd" inDirectory:@"ReadingListBundle.bundle"];
    NSURL *modelURL = [NSURL fileURLWithPath:path];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSLog(@"%@", model);
    
    XCTAssertNotNil(model, @"Instance of NSManagedObjectModel initialized with model name \"%@\" should not be nil. Model URL was %@", modelName, modelURL);
}

- (void)testEntityDescription
{
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:kModelName ofType:@"momd" inDirectory:@"ReadingListBundle.bundle"];
    NSURL *modelURL = [NSURL fileURLWithPath:path];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSDictionary *entities = model.entitiesByName;
    for (NSString *key in entities) {
        NSEntityDescription *entityDescription = entities[key];
        NSLog(@"\nEntity name: %@"
              @"\nMO class name: %@"
              @"\nAttributes: %@"
              @"\nRelationships: %@\n",
              key,
              entityDescription.managedObjectClassName,
              entityDescription.attributesByName,
              entityDescription.relationshipsByName);
    }
}

- (void)testCreateStore
{
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:kModelName ofType:@"momd" inDirectory:@"ReadingListBundle.bundle"];
    NSURL *modelURL = [NSURL fileURLWithPath:path];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSPersistentStore *store = [coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                         configuration:nil
                                                                   URL:RELPathForDocument(kStoreName, @"sqlite")
                                                               options:nil
                                                                 error:NULL];
    NSLog(@"%@", store);
    NSLog(@"%@", store.metadata);
}




@end
