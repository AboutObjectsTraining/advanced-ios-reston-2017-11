#import <CoreData/CoreData.h>
#import <ReadingListModel/ReadingListModel.h>

#import "RELAuthorDataSource.h"

// TODO: Provide a better reuse identifier.
static NSString * const kAuthorCellReuseIdentifier = @"AuthorCell";

@implementation RELAuthorDataSource

- (NSString *)cacheName          { return nil; }
- (NSString *)entityName         { return [RELAuthor entityName]; }
- (NSString *)sectionNameKeyPath { return nil; }
- (NSArray *)sortDescriptors     { return @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]; }

- (NSString *)reuseIdentifierForCellAtIndexPath:(NSIndexPath *)indexPath
{
    return kAuthorCellReuseIdentifier;
}

- (void)populateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    RELAuthor *author = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = author.name;
}

@end
