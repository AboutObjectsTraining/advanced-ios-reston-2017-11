#import "RELAddBookController.h"
#import "RELSelectAuthorController.h"
#import "UIStoryboardSegue+RELAdditions.h"

@interface RELAddBookController ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) RELBook *book;
@property (strong, nonatomic) RELAuthor *author;

@property (strong, nonatomic) UITextField *selectedTextField;

@end

@implementation RELAddBookController

#pragma mark - UIViewController

- (void)dealloc
{
    self.titleField.delegate = nil;
    self.yearField.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Creating a child managed object context here allows local state changes
    // to be managed independently of changes in the parent context.
    //
    NSManagedObjectContext *childContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    childContext.parentContext = self.fetchedResultsController.managedObjectContext;
    
    self.managedObjectContext = childContext;
    
    RELBook *newBook = [RELBook insertInManagedObjectContext:self.managedObjectContext];
    self.book = newBook;
    
    [self.titleField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.authorField.text = self.author.name;

    [self.tableView reloadData];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSError *error;
    if ([identifier hasPrefix:@"Done"] && ![self.managedObjectContext save:&error])
    {
        NSLog(@"Unable to save book %@\nError was %@ %@", self.book, error.localizedDescription, error.localizedFailureReason);
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Add Book"
                                                                            message:@"Unable to save book, because either the title or author weren't set."
                                                                     preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:controller animated:YES completion:nil];
        return NO;
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.selectedTextField resignFirstResponder];
    
    if ([segue.identifier hasPrefix:@"SelectAuthor"])
    {
        // Present Select Author controller modally...
        RELSelectAuthorController *authorsController = [segue rel_realDestinationViewController];
        authorsController.book = self.book;
    }
    else if ([segue.identifier hasPrefix:@"Cancel"]) {
        [self.managedObjectContext rollback];
    }
}


#pragma mark - Actions and Unwind Segues

- (void)doneSelectingAuthor:(UIStoryboardSegue *)segue
{
//    self.doneButton.enabled = self.book.author != nil;
    self.authorField.text = self.book.author.name;
}

- (void)cancelSelectingAuthor:(UIStoryboardSegue *)segue
{
    // 
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.titleField) {
        self.book.title = self.titleField.text;
    }
    else if (textField == self.yearField) {
        self.book.year = self.yearField.text;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.selectedTextField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField == self.titleField) {
        [self.yearField becomeFirstResponder];
    }

    return YES;
}

@end
