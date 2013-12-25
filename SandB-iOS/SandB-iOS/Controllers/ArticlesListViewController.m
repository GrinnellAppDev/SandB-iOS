//
//  ArticlesListViewController.m
//  SandB-iOS
//
//  Created by Maijid Moujaled on 12/23/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import "ArticlesListViewController.h"
#import "GlassViewController.h"
#import "Article.h"
#import "AFNetworking.h"
#import "SandBClient.h"
#import "DataModel.h"

@interface ArticlesListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *theTableView;
//@property (nonatomic, strong) NSMutableArray *articles;

@end

@implementation ArticlesListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
   // self.articles = [NSMutableArray new];
    
    /*
    Article *a1 = [[Article alloc] init];
    a1.image = [UIImage imageNamed:@"thomas.jpg"];
    a1.title = @"Thomas Neil is a baller";
    [self.articles addObject:a1];
    
    Article *a2 = [[Article alloc] init];
    a2.image = [UIImage imageNamed:@"game.jpg"];
    a2.title = @"Lea is cool..";
    [self.articles addObject:a2];
    
    Article *a3 = [[Article alloc] init];
    a3.image = [UIImage imageNamed:@"rink.jpg"];
    a3.title = @"But I'm not that easy.";
    [self.articles addObject:a3];
    
    Article *a4 = [[Article alloc] init];
    a4.title = @"I'm having such a hard time trying to not make out with you";
    a4.image = [UIImage imageNamed:@"town.jpg"];
    [self.articles addObject:a4];
    */
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[SandBClient sharedClient] GET:@"get_recent_posts/"
                         parameters:@{@"count": @(10),
                                      @"page": @(1)
                                      }
                            success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                                
                                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                
                                if (httpResponse.statusCode == 200) {
                                    NSArray *articleArray = responseObject[@"posts"];
                                    [articleArray enumerateObjectsUsingBlock:^(NSDictionary *articleDictionary, NSUInteger idx, BOOL *stop) {
                                        Article *article = [[Article alloc] initWithArticleDictionary:articleDictionary];
                                        [[[DataModel sharedModel] articles] addObject:article];
//                                        [self.articles addObject:article];
                                    }];
                                    [self.theTableView reloadData]; 
                                    //NSLog(@"articles: %@", self.articles);
                                }
                                
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                //Failure callback gets called when the request itself fails.
                                //ie sucess could mean you could "successfully" get a 500.
                                NSLog(@"Failure... %@", error);
                            }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[DataModel sharedModel] articles] count];
//    return self.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //Customize Cell
    Article *a = [[[DataModel sharedModel] articles] objectAtIndex:indexPath.row];
    //  self.articles[indexPath.row]
    
    cell.textLabel.text = a.title;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showGlassViews"]) {
        GlassViewController *glvc = segue.destinationViewController;
        glvc.articles = [[DataModel sharedModel] articles];
        
        //Push to the article that was tapped. 
        NSIndexPath *indexPath = [self.theTableView indexPathForCell:sender];
        glvc.page = indexPath.row;
    }
}

@end
