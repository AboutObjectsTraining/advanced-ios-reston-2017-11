// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RELBookCover.m instead.

#import "_RELBookCover.h"


const struct RELBookCoverAttributes RELBookCoverAttributes = {
	.thumbnail100x100 = @"thumbnail100x100",
	.thumbnailURL = @"thumbnailURL",
};



const struct RELBookCoverRelationships RELBookCoverRelationships = {
	.book = @"book",
};





const struct RELBookCoverUserInfo RELBookCoverUserInfo = {
};


@implementation _RELBookCover

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)context {
	NSParameterAssert(context);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BookCover" inManagedObjectContext:context];
}

+ (NSString *)entityName {
	return @"BookCover";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)context {
	NSParameterAssert(context);
	return [NSEntityDescription entityForName:@"BookCover" inManagedObjectContext:context];
}

- (RELBookCoverID *)objectID {
	return (RELBookCoverID *)[super objectID];
}




@dynamic thumbnail100x100;






@dynamic thumbnailURL;






@dynamic book;

	




@end



