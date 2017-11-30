#import <dispatch/dispatch.h>
#import "UIStoryboardSegue+RELAdditions.h"

#import "RELSearchController.h"
#import "RELSearchResultsController.h"

NSString * const RELSearchCriteriaTitleKey = @"RELSearchCriteriaTitleKey";
NSString * const RELSearchCriteriaAuthorKey = @"RELSearchCriteriaAuthorKey";


@implementation RELSearchController

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.searchTermsField becomeFirstResponder];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RELSearchResultsController *controller = [segue rel_realDestinationViewController];
    
    controller.searchTerms = self.searchTermsField.text;
}


#pragma mark - Actions


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self performSegueWithIdentifier:@"ShowResults" sender:nil];
    
    return YES;
}

@end
