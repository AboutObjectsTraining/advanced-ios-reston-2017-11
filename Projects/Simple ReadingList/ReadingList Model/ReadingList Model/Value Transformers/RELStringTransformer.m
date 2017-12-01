#import "RELStringTransformer.h"
#import "RELTransformerUtilities.h"

@implementation RELStringTransformer

+ (void)load
{
    RELRegisterValueTransformerClass([self class]);
}

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    return [value isKindOfClass:[NSArray class]] ? [value componentsJoinedByString:@", "] : value;
}

@end
