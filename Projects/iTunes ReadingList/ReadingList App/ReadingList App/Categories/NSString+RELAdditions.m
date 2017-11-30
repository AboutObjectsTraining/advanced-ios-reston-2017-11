#import "NSString+RELAdditions.h"

@implementation NSString (RELAdditions)

/**
 Returns an HTML document that has the provided string as its body content.
 @param string The body of an HTML document.
 @return An HTML document that contains the provided HTML body content.
 */
+ (nullable NSString *)rel_HTMLDocumentStringWithContent:(nullable NSString *)string
{
    if (string == nil) return  nil;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"synopsis" ofType:@"html"];
    NSString *HTMLString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    return [HTMLString stringByReplacingOccurrencesOfString:@"#BODY#" withString:string];
}

/**
 Returns a URL string percent escaped in conformance with RFC 3986.
 */
- (nullable NSString *)rel_stringByAddingPercentEscapes
{
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [characterSet addCharactersInString:@"-._~/?"];
    return [self stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
}

@end
