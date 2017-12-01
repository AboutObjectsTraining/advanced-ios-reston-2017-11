#import "RELUtilities.h"

/**
@return The URL to the application's Documents directory.
*/
NSURL *RELDocumentsDirectory(void)
{
    NSArray *URLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                           inDomains:NSUserDomainMask];
    return [URLs lastObject];
}

/**
@param name The document name.
@param type The document file format.
@return The URL of the desired document.
*/

NSURL *RELPathForDocument(NSString *name, NSString *type)
{
    return [[RELDocumentsDirectory() URLByAppendingPathComponent:name] URLByAppendingPathExtension:type];
}


BOOL isBlankString(NSString *s)
{
    NSCharacterSet *nonWhitespaceSet = [[NSCharacterSet whitespaceCharacterSet] invertedSet];
    NSRange range = [s rangeOfCharacterFromSet:nonWhitespaceSet];
    
    return s == nil || range.location == NSNotFound;
}