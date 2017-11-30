#import <CoreData/CoreData.h>
#import <ReadingListModel/ReadingListModel.h>

#import "RELReadingListDataSource.h"

static NSString * const kBookSummaryCellReuseIdentifier = @"BookSummary";


@implementation RELReadingListDataSource

- (NSString *)cacheName          { return RELReadingListCacheName; }
- (NSString *)entityName         { return [RELBook entityName]; }
- (NSString *)sectionNameKeyPath { return @"author.name"; }

- (NSPredicate *)predicate
{
    return [NSPredicate predicateWithFormat:@"iTunesID = 0"];
}

- (NSArray *)sortDescriptors
{
    return @[[NSSortDescriptor sortDescriptorWithKey:@"author.name" ascending:YES],
             [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO]];
}

- (NSString *)reuseIdentifierForCellAtIndexPath:(NSIndexPath *)indexPath
{
    return kBookSummaryCellReuseIdentifier;
}

- (void)populateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    RELBook *book = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = book.title;
}

@end
