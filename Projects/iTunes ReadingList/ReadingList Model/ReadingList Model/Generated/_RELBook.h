// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RELBook.h instead.

#import <CoreData/CoreData.h>
#import "RELManagedObject.h"



extern const struct RELBookAttributes {
NSString * __unsafe_unretained comments;
NSString * __unsafe_unretained favorite;
NSString * __unsafe_unretained genres;
NSString * __unsafe_unretained iTunesID;
NSString * __unsafe_unretained price;
NSString * __unsafe_unretained rating;
NSString * __unsafe_unretained thumbnail60x60;
NSString * __unsafe_unretained thumbnail60x60URL;
NSString * __unsafe_unretained title;
NSString * __unsafe_unretained year;
} RELBookAttributes;



extern const struct RELBookRelationships {
	NSString * __unsafe_unretained author;
	NSString * __unsafe_unretained cover;
	NSString * __unsafe_unretained synopsis;
} RELBookRelationships;





extern const struct RELBookUserInfo {
} RELBookUserInfo;


@class RELAuthor;
@class RELBookCover;
@class RELBookSynopsis;

@interface RELBookID : NSManagedObjectID
@end

@interface _RELBook : RELManagedObject

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSString *)entityName;
+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)context;
- (RELBookID *)objectID;





@property (nonatomic, strong) NSString* comments;



//- (BOOL)validateComments:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* favorite;




@property (atomic) BOOL favoriteValue;
- (BOOL)favoriteValue;
- (void)setFavoriteValue:(BOOL)value_;


//- (BOOL)validateFavorite:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) id genres;



//- (BOOL)validateGenres:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* iTunesID;




@property (atomic) int32_t iTunesIDValue;
- (int32_t)iTunesIDValue;
- (void)setITunesIDValue:(int32_t)value_;


//- (BOOL)validateITunesID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* price;



//- (BOOL)validatePrice:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* rating;




@property (atomic) int16_t ratingValue;
- (int16_t)ratingValue;
- (void)setRatingValue:(int16_t)value_;


//- (BOOL)validateRating:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) id thumbnail60x60;



//- (BOOL)validateThumbnail60x60:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) id thumbnail60x60URL;



//- (BOOL)validateThumbnail60x60URL:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* year;



//- (BOOL)validateYear:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) RELAuthor *author;

//- (BOOL)validateAuthor:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) RELBookCover *cover;

//- (BOOL)validateCover:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) RELBookSynopsis *synopsis;

//- (BOOL)validateSynopsis:(id*)value_ error:(NSError**)error_;




@end

