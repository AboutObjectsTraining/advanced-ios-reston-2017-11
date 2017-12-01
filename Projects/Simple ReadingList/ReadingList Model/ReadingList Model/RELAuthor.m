#import "RELAuthor.h"


@implementation RELAuthor

+ (NSDictionary *)iTunesMappingDictionary
{
    return @{ RELAuthorAttributes.iTunesID : RELiTunesAttributes.artistId,
              RELAuthorAttributes.name     : RELiTunesAttributes.artistName,
              };
}


@end
