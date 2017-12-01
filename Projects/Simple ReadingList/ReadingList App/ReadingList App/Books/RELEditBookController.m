#import <CoreData/CoreData.h>
#import <ReadingListModel/ReadingListModel.h>

#import "RELEditBookController.h"
#import "RELSelectAuthorController.h"
#import "UIStoryboardSegue+RELAdditions.h"


@interface RELEditBookController ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end


@implementation RELEditBookController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUndoManagerDidUndoChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUndoManagerDidRedoChangeNotification object:nil];
    
    self.titleField.delegate = nil;
    self.yearField.delegate = nil;
}

- (void)refresh
{
    self.titleField.text = self.book.title;
    self.yearField.text = self.book.year;
    self.authorLabel.text = self.book.author.name;
}

+ (UINib *)inputAccessoryNib
{
    static UINib *_nib;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _nib = [UINib nibWithNibName:@"UndoInputAccessory" bundle:nil];
    });
    return _nib;
}

- (UIToolbar *)inputAccessoryToolbar
{
    if (_inputAccessoryToolbar == nil) {
        [[[self class] inputAccessoryNib] instantiateWithOwner:self options:nil];
    }
    
    [self updateUndoRedoButtons];
    
    return _inputAccessoryToolbar;
}

- (UIView *)inputAccessoryView
{
    return self.inputAccessoryToolbar;
}


#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // TODO: Move to data source...
    //
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.parentContext = self.book.managedObjectContext;
    self.book = (RELBook *)[self.managedObjectContext objectWithID:self.book.objectID];
    
    [self configureUndoManager];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[self view] endEditing:YES];
    
    if ([[segue identifier] hasPrefix:@"SelectAuthor"]) {
        RELSelectAuthorController *controller = [segue rel_realDestinationViewController];
        controller.book = self.book;
    }
    else if ([[segue identifier] hasPrefix:@"Save"]) {
        NSError *error;
        BOOL saved = [self.managedObjectContext save:&error];
        if (!saved) {
            // TODO: Error handling.
        }
    }
    else if ([[segue identifier] hasPrefix:@"Cancel"]) {
        [self.managedObjectContext rollback];
    }
}


- (void)updateUndoRedoButtons
{
    self.redoButton.enabled = self.managedObjectContext.undoManager.canRedo;
    self.undoButton.enabled = self.managedObjectContext.undoManager.canUndo;
}

#pragma mark - Actions and Unwind Segues

- (void)redo:(UIBarButtonItem *)sender {
    
    [self.managedObjectContext redo];
    [self updateUndoRedoButtons];
}

- (void)undo:(UIBarButtonItem *)sender {
    
    [self.managedObjectContext undo];
    [self updateUndoRedoButtons];
}

- (void)doneSelectingAuthor:(UIStoryboardSegue *)segue
{
    self.authorLabel.text = self.book.author.name;
}

- (void)cancel:(UIStoryboardSegue *)segue
{
    
}


#pragma mark - UITextFieldDelegate

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    return YES;
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.undoButton.enabled = YES;
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.titleField) {
        NSString *newTitle = self.titleField.text;
        self.book.title = newTitle;
    }
    if (textField == self.yearField) {
        NSString *newYear = self.yearField.text;
        self.book.year = newYear;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return NO;
}


#pragma mark - Undo Manager

- (void)configureUndoManager
{
    if (self.managedObjectContext.undoManager == nil) {
        self.managedObjectContext.undoManager = [[NSUndoManager alloc] init];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(undoManagerDidUndo:)
                                                 name:NSUndoManagerDidUndoChangeNotification
                                               object:self.managedObjectContext.undoManager];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(undoManagerDidRedo:)
                                                 name:NSUndoManagerDidRedoChangeNotification
                                               object:self.managedObjectContext.undoManager];
}

- (void)undoManagerDidUndo:(NSNotification *)notification
{
    [self refresh];
}

- (void)undoManagerDidRedo:(NSNotification *)notification
{
    [self refresh];
}

@end
