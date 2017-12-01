#import "RELBookCover.h"

@implementation RELBookCover

+ (NSDictionary *)iTunesMappingDictionary
{
    return @{ RELBookCoverAttributes.thumbnailURL : RELiTunesAttributes.artworkUrl100,};
}


@end