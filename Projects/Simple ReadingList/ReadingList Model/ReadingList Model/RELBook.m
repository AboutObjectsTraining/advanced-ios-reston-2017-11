#import "RELUtilities.h"
#import "RELBook.h"
#import "RELAuthor.h"

// TODO: Move Me!
NSString * const RELModelErrorDomain = @"RELModelErrorDomain";
const NSInteger RELModelInvalidPropertyValue = 1;


@implementation RELBook

@synthesize thumbnail60x60URL = _thumbnail60x60URL;

+ (NSDictionary *)iTunesMappingDictionary
{
    return @{ RELBookAttributes.iTunesID          : RELiTunesAttributes.trackId,
              RELBookAttributes.title             : RELiTunesAttributes.trackName,
              RELBookAttributes.year              : RELiTunesAttributes.releaseDate,
              RELBookAttributes.genres            : RELiTunesAttributes.genres,
              RELBookAttributes.price             : RELiTunesAttributes.formattedPrice,
              RELBookAttributes.thumbnail60x60URL : RELiTunesAttributes.artworkUrl60,
              };
}

// Temporary hack for strings that contain more than just the year.
//
- (NSString *)year
{
    NSString *key = NSStringFromSelector(_cmd);
    
    [self willAccessValueForKey:key];
    NSString *year = [self primitiveValueForKey:key];
    [self didAccessValueForKey:key];
    
    return [year substringToIndex:4];
}


#pragma mark - Managed Object Validation

- (BOOL)validateAuthor:(id *)value error:(NSError **)error
{
    if (*value != nil)  return YES;
    
    // TODO: Look up localized strings.
    if (error != NULL) {
        *error = [NSError errorWithDomain:RELModelErrorDomain
                                     code:RELModelInvalidPropertyValue
                                 userInfo:@{NSLocalizedDescriptionKey: @"The \'author\' property cannot be nil"}];
    }
    
    return NO;
}

- (BOOL)validateTitle:(id *)value error:(NSError **)error
{
    if (!isBlankString(*value)) return YES;
    
    if (error != NULL) {
        *error = [NSError errorWithDomain:RELModelErrorDomain
                                     code:RELModelInvalidPropertyValue
                                 userInfo:@{NSLocalizedDescriptionKey: @"The \'title\' property cannot be blank"}];
    }
    
    return NO;
}

//- (BOOL)validateForInsert:(NSError **)error
//{
//    
//}

@end
