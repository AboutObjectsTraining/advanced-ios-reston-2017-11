#import "RELNumberTransformer.h"
#import "RELTransformerUtilities.h"

@implementation RELNumberTransformer

+ (void)load
{
    RELRegisterValueTransformerClass([self class]);
}

+ (Class)transformedValueClass
{
    return [NSNumber class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    return (value == nil ? nil :
            [value isKindOfClass:[NSNumber class]] ? value :
            [NSDecimalNumber decimalNumberWithString:value]);
}

@end
