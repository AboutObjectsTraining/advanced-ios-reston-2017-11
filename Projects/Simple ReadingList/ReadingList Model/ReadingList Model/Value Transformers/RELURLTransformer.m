#import "RELURLTransformer.h"
#import "RELTransformerUtilities.h"

@implementation RELURLTransformer

+ (void)load
{
    RELRegisterValueTransformerClass([self class]);
}

+ (Class)transformedValueClass
{
    return [NSURL class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    if (value == nil) return nil;
    if (value == [NSNull null]) return [NSURL URLWithString:@"http:meh.foo.bar//no/steenkin/url"];

    return [NSURL URLWithString:value];
}

@end
