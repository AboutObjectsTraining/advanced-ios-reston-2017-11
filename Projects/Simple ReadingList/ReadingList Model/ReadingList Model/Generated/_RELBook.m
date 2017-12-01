// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RELBook.m instead.

#import "_RELBook.h"


const struct RELBookAttributes RELBookAttributes = {
	.comments = @"comments",
	.favorite = @"favorite",
	.genres = @"genres",
	.iTunesID = @"iTunesID",
	.price = @"price",
	.rating = @"rating",
	.thumbnail60x60 = @"thumbnail60x60",
	.thumbnail60x60URL = @"thumbnail60x60URL",
	.title = @"title",
	.year = @"year",
};



const struct RELBookRelationships RELBookRelationships = {
	.author = @"author",
	.cover = @"cover",
	.synopsis = @"synopsis",
};





const struct RELBookUserInfo RELBookUserInfo = {
};


@implementation _RELBook

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)context {
	NSParameterAssert(context);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:context];
}

+ (NSString *)entityName {
	return @"Book";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)context {
	NSParameterAssert(context);
	return [NSEntityDescription entityForName:@"Book" inManagedObjectContext:context];
}

- (RELBookID *)objectID {
	return (RELBookID *)[super objectID];
}




@dynamic comments;






@dynamic favorite;



- (BOOL)favoriteValue {
	NSNumber *result = [self favorite];
	return [result boolValue];
}


- (void)setFavoriteValue:(BOOL)value_ {
	[self setFavorite:@(value_)];
}







@dynamic genres;






@dynamic iTunesID;



- (int32_t)iTunesIDValue {
	NSNumber *result = [self iTunesID];
	return [result intValue];
}


- (void)setITunesIDValue:(int32_t)value_ {
	[self setITunesID:@(value_)];
}







@dynamic price;






@dynamic rating;



- (int16_t)ratingValue {
	NSNumber *result = [self rating];
	return [result shortValue];
}


- (void)setRatingValue:(int16_t)value_ {
	[self setRating:@(value_)];
}







@dynamic thumbnail60x60;






@dynamic thumbnail60x60URL;






@dynamic title;






@dynamic year;






@dynamic author;

	

@dynamic cover;

	

@dynamic synopsis;

	




@end



