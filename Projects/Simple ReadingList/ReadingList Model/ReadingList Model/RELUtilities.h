#import <Foundation/Foundation.h>

NSURL *RELDocumentsDirectory(void);
NSURL *RELPathForDocument(NSString *name, NSString *type);

BOOL isBlankString(NSString *s);