#import "RELAddAuthorController.h"
#import "RELAddBookController.h"

@implementation RELAddAuthorController

- (void)dealloc
{
    self.nameField.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier hasPrefix:@"Done"])
    {
        self.author = [RELAuthor insertInManagedObjectContext:self.managedObjectContext];
        self.author.name = self.nameField.text;
    }
}

@end
