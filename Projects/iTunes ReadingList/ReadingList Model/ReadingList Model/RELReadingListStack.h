#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface RELReadingListStack : NSObject

+ (instancetype)defaultStack;

@property (readonly, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, nonatomic) NSManagedObjectContext *initialManagedObjectContext;

- (NSURL *)initialStoreURL;

- (NSString *)modelName;

@end
