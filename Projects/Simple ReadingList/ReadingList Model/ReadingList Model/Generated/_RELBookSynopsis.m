// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RELBookSynopsis.m instead.

#import "_RELBookSynopsis.h"


const struct RELBookSynopsisAttributes RELBookSynopsisAttributes = {
	.text = @"text",
};



const struct RELBookSynopsisRelationships RELBookSynopsisRelationships = {
	.book = @"book",
};





const struct RELBookSynopsisUserInfo RELBookSynopsisUserInfo = {
};


@implementation _RELBookSynopsis

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)context {
	NSParameterAssert(context);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BookSynopsis" inManagedObjectContext:context];
}

+ (NSString *)entityName {
	return @"BookSynopsis";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)context {
	NSParameterAssert(context);
	return [NSEntityDescription entityForName:@"BookSynopsis" inManagedObjectContext:context];
}

- (RELBookSynopsisID *)objectID {
	return (RELBookSynopsisID *)[super objectID];
}




@dynamic text;






@dynamic book;

	




@end



