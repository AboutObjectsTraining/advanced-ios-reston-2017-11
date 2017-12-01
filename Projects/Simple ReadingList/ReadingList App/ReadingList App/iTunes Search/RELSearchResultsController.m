#import <CoreData/CoreData.h>
#import <ReadingListModel/ReadingListModel.h>
#import "NSString+RELAdditions.h"

#import "UIStoryboardSegue+RELAdditions.h"

#import "RELSearchResultsController.h"
#import "RELSearchResultsDataSource.h"
#import "RELSearchResultsDetailController.h"

#import "RELSearchResultsDetailController.h" // TODO: Delete Me.


@interface RELSearchResultsController ()

@property (strong, nonatomic) NSURLSessionDataTask *searchTask;

@end


@implementation RELSearchResultsController

- (void)dealloc
{
    [_searchTask cancel];
}

- (void)setSearchTerms:(NSString *)searchTerms
{
    if ([searchTerms isEqualToString:self.searchTerms]) {
        return;
    }
    
    _searchTerms = [searchTerms copy];
    
    if (_searchTerms != nil)
    {
        [self performiTunesSearch];
        [self.tableView reloadData];
    }
}

- (NSURL *)searchURL
{
    NSNumber *batchSize = [[NSUserDefaults standardUserDefaults] objectForKey:RELiTunesSearchBatchSizeKey];
    
    // TODO: Externalize string...
    NSString *URLString = [NSString stringWithFormat:@"https://itunes.apple.com/search?media=ebook&term=%@&limit=%d",
                           self.searchTerms, [batchSize intValue]];
    return [NSURL URLWithString:[URLString rel_stringByAddingPercentEscapes]];
}


#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // TODO: Figure out why tab bar isn't showing...
    //
    [self setHidesBottomBarWhenPushed:NO];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    RELBook *book = [self.dataSource objectAtIndexPath:indexPath];
    
    if ([segue.identifier hasPrefix:@"View"]) {
        [segue.rel_realDestinationViewController setBook:book];
    }
}


#pragma mark - Actions and Unwind Segues

- (void)cancel
{
    [self.searchTask cancel];
    self.searchTask = nil;
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)doneViewingBook:(UIStoryboardSegue *)segue { }

#pragma mark - Performing a Search

- (void)showActivityIndicator:(BOOL)shouldShow
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = shouldShow; // TODO: Generalize.
    
    if (shouldShow)
        [self.activityIndicator startAnimating];
    else
        [self.activityIndicator stopAnimating];
    
    self.tableView.tableFooterView = shouldShow ? self.activityBackgroundView : nil;
}

- (void)showSearchResultsWithData:(NSData *)data
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    DLOG(@"%@", dict);
    
    [self.dataSource insertObjectsFromDictionaries:dict[RELiTunesAttributes.results]];
}

// NOTE: Demos syncing secondary thread with the main queue.
//
- (void)performiTunesSearch
{
    [self showActivityIndicator:YES];
    
    self.searchTask = [[NSURLSession sharedSession]
                       dataTaskWithURL:self.searchURL
                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                           [self completeiTunesSearchWithData:data response:(NSHTTPURLResponse *)response error:error];
                       }];
    
    [self.searchTask resume];
}

// NOTE: Discuss GCD and dispatching work on the main queue.
//
- (void)completeiTunesSearchWithData:(NSData *)data response:(NSHTTPURLResponse *)response error:(NSError *)error
{
    BOOL isValidResponse = data != nil && response.statusCode == 200;
    
    if (isValidResponse)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showSearchResultsWithData:data];
        });
    }
    else
    {
        DLOG(@"%@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"iTunes Search", @"iTunes Search alert view title")
                                                                                message:error.localizedDescription
                                                                         preferredStyle:UIAlertControllerStyleAlert];
            [controller addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:controller animated:YES completion:nil];
        });
    }
    
    self.searchTask = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showActivityIndicator:NO];
    });
}

@end
