#import "RELTransformerUtilities.h"

NSString *RELTransformerNameForClass(Class targetType)
{
    NSString *targetClassName = NSStringFromClass(targetType);
    if ([targetClassName hasPrefix:@"NS"]) {
        targetClassName = [targetClassName substringFromIndex:2];
    }
    
    return [NSString stringWithFormat:@"REL%@Transformer", targetClassName];
}

NSString *RELTransformerNameForClassName(NSString *className)
{
    return RELTransformerNameForClass(NSClassFromString(className));
}

void RELRegisterValueTransformerClass(Class transformerClass)
{
    NSString *name = RELTransformerNameForClass([transformerClass transformedValueClass]);
    
    if ([transformerClass valueTransformerForName:name] == nil)
    {
        [transformerClass setValueTransformer:[[transformerClass alloc] init] forName:name];
    }
}
