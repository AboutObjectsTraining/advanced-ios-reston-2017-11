#import <ReadingListModel/ReadingListModel.h>

#import "RELViewBookController.h"
#import "RELEditBookController.h"
#import "UIStoryboardSegue+RELAdditions.h"

NSString * const RELSelectedBookKey = @"RELSelectedBook";
NSString * const RELViewBookControllerDidSelectBookNotification = @"RELViewBookControllerDidSelectBookNotification";

@interface RELViewBookController ()

@property (strong, nonatomic) NSURLSessionDataTask *thumbnailTask;

@end


@implementation RELViewBookController

- (void)dealloc
{
    [_thumbnailTask cancel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.titleLabel.text = self.book.title;
    self.yearLabel.text = self.book.year;
    self.nameLabel.text = self.book.author.name;
    self.priceLabel.text = self.book.price;
    self.genresLabel.text = self.book.genres;
    self.thumbnailImageView.image = self.book.cover.thumbnail100x100;
    
    // If the book is already in the reading list, don't allow the user
    // to add it again. We're using the *initial* MOC here because RELSearchResultsDetailController
    // uses an instance of RELViewBookController to present MOs created in a separate
    // MOC (the one we use to populate MOs with data fetched from the iTunes web service).
    //
    RELBook *storedBook = [[RELDataSource class] fetchObjectWithiTunesID:self.book.iTunesID
                                                              entityName:[RELBook entityName]
                                                    managedObjectContext:[RELReadingListStack defaultStack].initialManagedObjectContext];
    
    self.addToReadingListButton.enabled = (storedBook == nil);
    self.editBarButtonItem.enabled = ([storedBook.iTunesID intValue] == 0);
    
    if (self.book.cover.thumbnail100x100 == nil) {
        [self fetchThumbnailImage];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier hasPrefix:@"EditBook"]) {
        RELEditBookController *editController = [segue rel_realDestinationViewController];
        editController.book = self.book;
    }
}


#pragma mark - Actions and Unwind Segues

- (IBAction)addToReadingList
{
    [[NSNotificationCenter defaultCenter] postNotificationName:RELViewBookControllerDidSelectBookNotification
                                                        object:self
                                                      userInfo:@{ RELSelectedBookKey : self.book }];
    self.addToReadingListButton.enabled = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.addedCheckmark.alpha = 1.0;
    }];
}


#pragma mark - NSURLSession

- (void)cancelSelectingAuthor:(UIStoryboardSegue *)segue { }

- (void)fetchThumbnailImage
{
    NSURL *thumbnailURL = [NSURL URLWithString:self.book.cover.thumbnailURL];
    
    self.thumbnailTask = [[NSURLSession sharedSession] dataTaskWithURL:thumbnailURL
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                         [self setThumbnailImageWithData:data response:(NSHTTPURLResponse *) response error:error];
                                                     }];
    [self.thumbnailTask resume];
}

- (void)setThumbnailImageWithData:(NSData *)data response:(NSHTTPURLResponse *)response error:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.book.cover = [RELBookCover insertInManagedObjectContext:self.book.managedObjectContext];
        self.book.cover.thumbnail100x100 = (response.statusCode == 200 ?
                                            [UIImage imageWithData:data] :
                                            [UIImage imageNamed:@"NoCover"]);
        self.thumbnailImageView.image = self.book.cover.thumbnail100x100;
    });
    
    self.thumbnailTask = nil;
}

@end
