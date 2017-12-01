// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RELBookCover.h instead.

#import <CoreData/CoreData.h>
#import "RELManagedObject.h"



extern const struct RELBookCoverAttributes {
NSString * __unsafe_unretained thumbnail100x100;
NSString * __unsafe_unretained thumbnailURL;
} RELBookCoverAttributes;



extern const struct RELBookCoverRelationships {
	NSString * __unsafe_unretained book;
} RELBookCoverRelationships;





extern const struct RELBookCoverUserInfo {
} RELBookCoverUserInfo;


@class RELBook;

@interface RELBookCoverID : NSManagedObjectID
@end

@interface _RELBookCover : RELManagedObject

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSString *)entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)context;
- (RELBookCoverID *)objectID;





@property (nonatomic, strong) id thumbnail100x100;



//- (BOOL)validateThumbnail100x100:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* thumbnailURL;



//- (BOOL)validateThumbnailURL:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) RELBook *book;

//- (BOOL)validateBook:(id*)value_ error:(NSError**)error_;




@end

