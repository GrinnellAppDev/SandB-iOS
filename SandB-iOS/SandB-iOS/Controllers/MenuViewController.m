
#import <MessageUI/MessageUI.h>
#import <StoreKit/StoreKit.h>

#import "ArticlesListTableViewController.h"
#import "DataModel.h"
#import "MenuViewController.h"
#import "NewsCategories.h"
#import "UIViewController+ECSlidingViewController.h"

@interface MenuViewController () <SKStoreProductViewControllerDelegate, MFMailComposeViewControllerDelegate>

@end

@implementation MenuViewController {
    NSArray *categoriesTitles;
    NSArray *toolsTitles;
    NSArray *categoryColors;
    NSArray *selectedCategoryColors;
    BOOL firstOpen;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[NewsCategories sharedCategories] categoriesWithData];
    
    categoriesTitles = [[[NewsCategories sharedCategories] categories] objectForKey:@"names"];
    categoryColors = [[[NewsCategories sharedCategories] categories] objectForKey:@"colors"];
    selectedCategoryColors = [[[NewsCategories sharedCategories] categories] objectForKey:@"highlighted"];
        
    toolsTitles = @[@"Saved Articles", @"Rate Our App", @"Contact Us"];
    
    self.view.backgroundColor = [UIColor colorWithRed:140.0/255
                                                green:29.0/255
                                                 blue:41.0/255
                                                alpha:1.0];
    
    self.slidingViewController.anchorRightRevealAmount = 200.0;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 45;
    }
    
    else {
        return 20.0f;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return 6;
    }
    
    else {
        return 3;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    else {
        return @"Tools";
    }
}

- (void)tableView:(UITableView *)tableView
    willDisplayHeaderView:(UIView *)view
               forSection:(NSInteger)section {
    
        UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
        header.tintColor = [UIColor colorWithRed:140.0/255 green:29.0/255 blue:41.0/255 alpha:1.0];
        header.textLabel.textColor = [UIColor whiteColor];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indetifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indetifier
                                                            forIndexPath:indexPath];
    
    // Configure the cell...
    
    UIView *categoryIndicator;
    
    if (indexPath.section == 0) {
        cell.textLabel.text = categoriesTitles[indexPath.row];
        categoryIndicator = (UIView *) [cell viewWithTag:10];
        categoryIndicator.backgroundColor = categoryColors[indexPath.row];
        
        // TO DO: Make sure to change background color of first cell white, when something else is selected
        if (indexPath.row == 0) {
                cell.backgroundColor = [UIColor colorWithRed:140.0/255
                                                       green:29.0/255
                                                        blue:41.0/255
                                                       alpha:0.05];
        }
        cell.textLabel.textColor = categoryColors[indexPath.row];
        [cell.textLabel setFont:[UIFont fontWithName:@"ProximaNova-Light" size:22]];
    }
    
    if (indexPath.section == 1) {
        cell.textLabel.text = toolsTitles[indexPath.row];
        categoryIndicator = (UIView *) [cell viewWithTag:10];
        categoryIndicator.backgroundColor = [UIColor colorWithRed:140.0/255
                                                            green:29.0/255
                                                             blue:41.0/255
                                                            alpha:1.0];
        [cell.textLabel setFont:[UIFont fontWithName:@"ProximaNova-Light" size:18]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *firstCell = [tableView cellForRowAtIndexPath:firstIndexPath];
    
    if (indexPath.section == 0) {
        if (!(firstCell.backgroundColor == [UIColor whiteColor])) {
            firstCell.backgroundColor = [UIColor whiteColor];
        }
        cell.backgroundColor = selectedCategoryColors[indexPath.row];
    }
    
    if (indexPath.section == 1) {
        if (0 == indexPath.row) {
            cell.backgroundColor = [UIColor colorWithRed:140.0/255 green:29.0/255 blue:41.0/255 alpha:0.05];
        }
    }
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
}

-(IBAction)dontfail:(id)sender {
    self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"failedNav"];
    [self.slidingViewController resetTopViewAnimated:YES];
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if (indexPath.section == 0) {
        if ([segue.identifier isEqualToString:@"GoToCategory"]) {
            UINavigationController *nc = segue.destinationViewController;
            ArticlesListTableViewController *naltvc = [nc.viewControllers objectAtIndex:0];
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            

            NSString *categoryString = categoriesTitles[indexPath.row];
            naltvc.recievedCategory = categoryString;
        }
    } else {
        if (indexPath.row == 0) {
            if ([segue.identifier isEqualToString:@"GoToCategory"]) {
                UINavigationController *nc = segue.destinationViewController;
                ArticlesListTableViewController *naltvc = [nc.viewControllers objectAtIndex:0];
                
                NSString *categoryString = @"Favorites";
                naltvc.recievedCategory = categoryString;
            }
        } else if (indexPath.row == 1) {
            [self rateSnB];
        } else {
            [self contactUs];
        }
    }
}

- (void)contactUs {
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        
        mailViewController.navigationBar.tintColor = [UIColor whiteColor];
        
        mailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        
        [mailViewController setSubject:@"Feedback - S&B"];
        [mailViewController setToRecipients:[NSArray arrayWithObject:@"appdev@grinnell.edu"]];
        [self presentViewController:mailViewController animated:YES completion:nil];
    }
}

- (void)rateSnB {
    NSDictionary *parameters = [NSDictionary dictionaryWithObject:@"638912711"
                                                           forKey:SKStoreProductParameterITunesItemIdentifier];
    SKStoreProductViewController *productViewController = [[SKStoreProductViewController alloc] init];
    productViewController.delegate = self;
    [productViewController loadProductWithParameters:parameters completionBlock:nil];
    [self presentViewController:productViewController animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self viewDidLoad];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
