#import <ReadingListModel/ReadingListModel.h>

extern NSString * const RELiTunesSearchConcurrentOperationCountKey;


@interface RELSearchResultsDataSource : RELDataSource

- (void)insertObjectsFromDictionaries:(NSArray *)dictionaries;

@end
