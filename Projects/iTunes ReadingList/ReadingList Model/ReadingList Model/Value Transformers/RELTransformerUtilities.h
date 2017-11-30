#import <Foundation/Foundation.h>

NSString *RELTransformerNameForClassName(NSString *className);
NSString *RELTransformerNameForClass(Class targetType);
void RELRegisterValueTransformerClass(Class transformerClass);
