#import <CoreData/CoreData.h>

struct RELiTunesAttributes {
    NSString * __unsafe_unretained results;
    NSString * __unsafe_unretained artistId;
    NSString * __unsafe_unretained artistName;
    NSString * __unsafe_unretained trackId;
    NSString * __unsafe_unretained trackName;
    NSString * __unsafe_unretained releaseDate;
    NSString * __unsafe_unretained genres;
    NSString * __unsafe_unretained formattedPrice;
    NSString * __unsafe_unretained artworkUrl60;
    NSString * __unsafe_unretained artworkUrl100;
    NSString * __unsafe_unretained averageUserRating;
    NSString * __unsafe_unretained description;
};
extern const struct RELiTunesAttributes RELiTunesAttributes;


@interface RELManagedObject : NSManagedObject

+ (NSDictionary *)iTunesMappingDictionary;
- (void)setAttributeValuesWithiTunesDictionary:(NSDictionary *)iTunesValues;

- (NSDictionary *)attributeValues;

@end
