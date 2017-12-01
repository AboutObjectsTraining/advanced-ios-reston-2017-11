#import <Foundation/Foundation.h>

@interface NSString (RELAdditions)
+ (nullable NSString *)rel_HTMLDocumentStringWithContent:(nullable NSString *)string;
- (nullable NSString *)rel_stringByAddingPercentEscapes;
@end
