#import "RELBookSynopsis.h"

@implementation RELBookSynopsis

+ (NSDictionary *)iTunesMappingDictionary
{
    return @{ RELBookSynopsisAttributes.text : RELiTunesAttributes.description,
              };
}


@end