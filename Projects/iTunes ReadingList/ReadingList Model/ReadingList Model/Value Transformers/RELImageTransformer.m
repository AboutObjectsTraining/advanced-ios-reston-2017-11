#import "RELImageTransformer.h"
#import "RELTransformerUtilities.h"

@implementation RELImageTransformer

+ (void)load
{
    RELRegisterValueTransformerClass([self class]);
}

+ (Class)transformedValueClass
{
    return [UIImage class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    return (value == nil ? nil : UIImagePNGRepresentation(value));
}

- (id)reverseTransformedValue:(id)value
{
    return (value == nil ? nil : [UIImage imageWithData:value]);
}

@end
