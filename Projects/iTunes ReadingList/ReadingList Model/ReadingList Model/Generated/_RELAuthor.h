// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RELAuthor.h instead.

#import <CoreData/CoreData.h>
#import "RELManagedObject.h"



extern const struct RELAuthorAttributes {
NSString * __unsafe_unretained iTunesID;
NSString * __unsafe_unretained name;
NSString * __unsafe_unretained rating;
} RELAuthorAttributes;



extern const struct RELAuthorRelationships {
	NSString * __unsafe_unretained books;
} RELAuthorRelationships;





extern const struct RELAuthorUserInfo {
} RELAuthorUserInfo;


@class RELBook;

@interface RELAuthorID : NSManagedObjectID
@end

@interface _RELAuthor : RELManagedObject

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSString *)entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)context;
- (RELAuthorID *)objectID;





@property (nonatomic, strong) NSNumber* iTunesID;




@property (atomic) int32_t iTunesIDValue;
- (int32_t)iTunesIDValue;
- (void)setITunesIDValue:(int32_t)value_;


//- (BOOL)validateITunesID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* rating;




@property (atomic) int16_t ratingValue;
- (int16_t)ratingValue;
- (void)setRatingValue:(int16_t)value_;


//- (BOOL)validateRating:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSOrderedSet *books;

- (NSMutableOrderedSet*)booksSet;




@end


@interface _RELAuthor (BooksCoreDataGeneratedAccessors)
- (void)addBooks:(NSOrderedSet *)value_;
- (void)removeBooks:(NSOrderedSet *)value_;
- (void)addBooksObject:(RELBook *)value_;
- (void)removeBooksObject:(RELBook *)value_;
@end
