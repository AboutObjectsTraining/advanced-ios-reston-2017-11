// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RELBookSynopsis.h instead.

#import <CoreData/CoreData.h>
#import "RELManagedObject.h"



extern const struct RELBookSynopsisAttributes {
NSString * __unsafe_unretained text;
} RELBookSynopsisAttributes;



extern const struct RELBookSynopsisRelationships {
	NSString * __unsafe_unretained book;
} RELBookSynopsisRelationships;





extern const struct RELBookSynopsisUserInfo {
} RELBookSynopsisUserInfo;


@class RELBook;

@interface RELBookSynopsisID : NSManagedObjectID
@end

@interface _RELBookSynopsis : RELManagedObject

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSString *)entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)context;
- (RELBookSynopsisID *)objectID;





@property (nonatomic, strong) NSString* text;



//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) RELBook *book;

//- (BOOL)validateBook:(id*)value_ error:(NSError**)error_;




@end

