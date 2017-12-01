#import "RELManagedObject.h"
#import "RELTransformerUtilities.h"

const struct RELiTunesAttributes RELiTunesAttributes = {
    .results           = @"results",
    .artistId          = @"artistId",
    .artistName        = @"artistName",
    .trackId           = @"trackId",
    .trackName         = @"trackName",
    .releaseDate       = @"releaseDate",
    .genres            = @"genres",
    .formattedPrice    = @"formattedPrice",
    .artworkUrl60      = @"artworkUrl60",
    .artworkUrl100     = @"artworkUrl100",
    .averageUserRating = @"averageUserRating",
    .description       = @"description",
};


@implementation RELManagedObject

+ (NSDictionary *)iTunesMappingDictionary
{
    return @{};
}

- (void)setAttributeValuesWithiTunesDictionary:(NSDictionary *)iTunesValues
{
    NSArray *propertyKeys = [self.class iTunesMappingDictionary].allKeys;
    NSDictionary *attributes = self.entity.attributesByName;
    
    for (NSString *propertyKey in propertyKeys)
    {
        NSString *iTunesKey = [self.class iTunesMappingDictionary][propertyKey];
        id value = iTunesValues[iTunesKey];
        
        if (value == nil) {
            continue;
        }
        
        NSAttributeDescription *description = attributes[propertyKey];
        NSString *targetClassName = description.attributeValueClassName;
        if (targetClassName == nil) {
            targetClassName = description.userInfo[@"targetClass"];
        }

        NSString *transformerName = RELTransformerNameForClassName(targetClassName);
        
        NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:transformerName];
        if (transformer != nil) {
            value = [transformer transformedValue:value];
        }
        
        [self setValue:value forKey:propertyKey];
    }
}

- (NSDictionary *)attributeValues
{
    return [self dictionaryWithValuesForKeys:self.entity.attributesByName.allKeys];
}


@end
