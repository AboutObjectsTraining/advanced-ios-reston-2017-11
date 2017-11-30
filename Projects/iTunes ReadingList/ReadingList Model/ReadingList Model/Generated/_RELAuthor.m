// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RELAuthor.m instead.

#import "_RELAuthor.h"


const struct RELAuthorAttributes RELAuthorAttributes = {
	.iTunesID = @"iTunesID",
	.name = @"name",
	.rating = @"rating",
};



const struct RELAuthorRelationships RELAuthorRelationships = {
	.books = @"books",
};





const struct RELAuthorUserInfo RELAuthorUserInfo = {
};


@implementation _RELAuthor

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)context {
	NSParameterAssert(context);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Author" inManagedObjectContext:context];
}

+ (NSString *)entityName {
	return @"Author";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)context {
	NSParameterAssert(context);
	return [NSEntityDescription entityForName:@"Author" inManagedObjectContext:context];
}

- (RELAuthorID *)objectID {
	return (RELAuthorID *)[super objectID];
}




@dynamic iTunesID;



- (int32_t)iTunesIDValue {
	NSNumber *result = [self iTunesID];
	return [result intValue];
}


- (void)setITunesIDValue:(int32_t)value_ {
	[self setITunesID:@(value_)];
}







@dynamic name;






@dynamic rating;



- (int16_t)ratingValue {
	NSNumber *result = [self rating];
	return [result shortValue];
}


- (void)setRatingValue:(int16_t)value_ {
	[self setRating:@(value_)];
}







@dynamic books;

	
- (NSMutableOrderedSet*)booksSet {
	[self willAccessValueForKey:@"books"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"books"];
  
	[self didAccessValueForKey:@"books"];
	return result;
}
	




@end


@implementation _RELAuthor (BooksCoreDataGeneratedAccessors)
- (void)addBooks:(NSOrderedSet*)value_ {
	[self.booksSet unionOrderedSet:value_];
}
- (void)removeBooks:(NSOrderedSet*)value_ {
	[self.booksSet minusOrderedSet:value_];
}
- (void)addBooksObject:(RELBook*)value_ {
	[self.booksSet addObject:value_];
}
- (void)removeBooksObject:(RELBook*)value_ {
	[self.booksSet removeObject:value_];
}
@end


