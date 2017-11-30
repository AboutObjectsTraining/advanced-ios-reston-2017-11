#import <CoreData/CoreData.h>
#import <ReadingListModel/ReadingListModel.h>

#import "RELiTunesReadingListDataSource.h"
#import "RELiTunesReadingListCell.h"
#import "RELViewBookController.h"

@implementation RELiTunesReadingListDataSource

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:RELViewBookControllerDidSelectBookNotification
                                                  object:nil];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewBookControllerDidSelectBook:)
                                                 name:RELViewBookControllerDidSelectBookNotification
                                               object:nil];
}

- (void)populateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    RELBook *book = [self.fetchedResultsController objectAtIndexPath:indexPath];
    RELiTunesReadingListCell *iTunesCell = (RELiTunesReadingListCell *)cell;
    iTunesCell.titleLabel.text = book.title;
    iTunesCell.thumbnailImageView.image = book.thumbnail60x60;
}

- (NSPredicate *)predicate
{
    return [NSPredicate predicateWithFormat:@"iTunesID != 0"];
}


#pragma mark - NSNotificationCenter Callbacks

- (void)viewBookControllerDidSelectBook:(NSNotification *)notification
{
    [self insertCopyOfBook:notification.userInfo[RELSelectedBookKey]];
}

- (void)insertCopyOfBook:(RELBook *)bookToCopy
{
    RELBook *storedBook = [self fetchObjectWithiTunesID:bookToCopy.iTunesID
                                             entityName:[bookToCopy.class entityName]];
    if (storedBook != nil) {
        DLOG(@"WARNING: Attempt to insert duplicate book %@", bookToCopy);
        return;
    }
    
    RELAuthor *author = [self fetchObjectWithiTunesID:bookToCopy.author.iTunesID
                                           entityName:[bookToCopy.author.class entityName]];
    
    DLOG(@"\n***Fetched author: %@\n", author);
    
    if (author == nil) {
        author = [RELAuthor insertInManagedObjectContext:self.managedObjectContext];
        [author setValuesForKeysWithDictionary:bookToCopy.author.attributeValues];
    }
    
    RELBook *newBook = [RELBook insertInManagedObjectContext:self.managedObjectContext];
    [newBook setValuesForKeysWithDictionary:bookToCopy.attributeValues];
    newBook.author = author;
    
    RELBookCover *coverToCopy = bookToCopy.cover;
    if (coverToCopy != nil) {
        RELBookCover *newCover = [RELBookCover insertInManagedObjectContext:self.managedObjectContext];
        [newCover setValuesForKeysWithDictionary:coverToCopy.attributeValues];
        newCover.thumbnail100x100 = coverToCopy.thumbnail100x100;
        newBook.cover = newCover;
    }
    
    [self save:NULL];
}


@end
