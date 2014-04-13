//
//  MenuViewController.m
//  SandB-iOS
//
//  Created by Lea Marolt on 4/6/14.
//  Copyright (c) 2014 Grinnell AppDev. All rights reserved.
//

#import "MenuViewController.h"
#import "NewsCategories.h"
#import "UIViewController+ECSlidingViewController.h"
#import "SpecificCategoryArticlesListViewController.h"
#import "NewArticlesListTableViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController {
    NSArray *categoriesTitles;
    NSArray *toolsTitles;
    NSArray *categoryColors;
    NSArray *selectedCategoryColors;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[NewsCategories sharedCategories] categoriesWithData];
    
    categoriesTitles = [[[NewsCategories sharedCategories] categories] objectForKey:@"names"];
    categoryColors = [[[NewsCategories sharedCategories] categories] objectForKey:@"colors"];
    selectedCategoryColors = [[[NewsCategories sharedCategories] categories] objectForKey:@"highlighted"];
    
    NSLog(@"highlighted colors: %@", categoryColors);
    
    toolsTitles = @[@"Saved Articles", @"Rate Our App", @"Contact Us"];
    
    self.view.backgroundColor = [UIColor colorWithRed:140.0/255 green:29.0/255 blue:41.0/255 alpha:1.0];
    
    self.slidingViewController.anchorRightRevealAmount = 200.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
        return @"Categories";
    }
    else {
        return @"Tools";
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.tintColor = [UIColor colorWithRed:140.0/255 green:29.0/255 blue:41.0/255 alpha:1.0];
    header.textLabel.textColor = [UIColor whiteColor];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indetifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indetifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    UIView *categoryIndicator;
    
    if (indexPath.section == 0) {
        cell.textLabel.text = categoriesTitles[indexPath.row];
        categoryIndicator = (UIView *) [cell viewWithTag:10];
        categoryIndicator.backgroundColor = categoryColors[indexPath.row];
        
        // TO DO: Make sure to change background color of first cell white, when something else is selected
        if (indexPath.row == 0) {
            cell.backgroundColor = [UIColor colorWithRed:140.0/255 green:29.0/255 blue:41.0/255 alpha:0.1];
        }
        cell.textLabel.textColor = categoryColors[indexPath.row];
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:22]];
    }
    
    if (indexPath.section == 1) {
        cell.textLabel.text = toolsTitles[indexPath.row];
        categoryIndicator = (UIView *) [cell viewWithTag:10];
        categoryIndicator.backgroundColor = [UIColor colorWithRed:140.0/255 green:29.0/255 blue:41.0/255 alpha:1.0];
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:22]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.backgroundColor = selectedCategoryColors[indexPath.row];
        
        
        // TO DO: Make the selected row be the color of the category that gets displayed in the main view
    }
    
    if (indexPath.section == 1) {
        cell.backgroundColor = [UIColor colorWithRed:140.0/255 green:29.0/255 blue:41.0/255 alpha:0.1];
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
    if ([segue.identifier isEqualToString:@"GoToCategory"]) {
        UINavigationController *nc = segue.destinationViewController;
        NewArticlesListTableViewController *naltvc = [nc.viewControllers objectAtIndex:0];
        NSIndexPath *indexPath = [self.theTableView indexPathForCell:sender];
            
        NSString *categoryString = categoriesTitles[indexPath.row];
        naltvc.recievedCategory = categoryString;
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - ECSliding Methods

- (IBAction)unwindToMenuViewController: (UIStoryboardSegue *) segue {
    
}

//-(IBAction)dontfail:(id)sender {
//    self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"failedNav"];
//    [self.slidingViewController resetTopViewAnimated:YES];
//    
//}

@end
