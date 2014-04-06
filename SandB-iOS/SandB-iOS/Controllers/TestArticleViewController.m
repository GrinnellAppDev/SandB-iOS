//
//  TestViewController.m
//  SandB-iOS
//
//  Created by Maijid Moujaled on 12/24/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import "TestArticleViewController.h"
#import "FBShimmeringView.h"

@interface TestArticleViewController ()
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@end

@implementation TestArticleViewController {
    FBShimmeringView *shimmerView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLayoutSubviews {
    [self.backgroundView setFrame:CGRectMake(self.backgroundView.frame.origin.x, self.backgroundView.frame.origin.y, self.backgroundView.frame.size.width, ([self textViewHeight:self.contentTextView] + 200))];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    self.contentViewHeight.constant = [self textViewHeight:self.contentTextView];
}

- (CGFloat)textViewHeight:(UITextView *)textView
{
    [textView.layoutManager ensureLayoutForTextContainer:textView.textContainer];
    CGRect usedRect = [textView.layoutManager
                       usedRectForTextContainer:textView.textContainer];
    return ceilf(usedRect.size.height
                 + textView.textContainerInset.top
                 + textView.textContainerInset.bottom);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.contentTextView.attributedText = self.article.attrContent;

}

-(void)viewWillLayoutSubviews {
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSLog(@"scv: %@", self.article.attrContent);
	// Do any additional setup after loading the view.
    self.testLabel.text = self.article.title;
    if (self.article.author) {
        self.authorLabel.text =  [NSString stringWithFormat:@"By %@", self.article.author];
    }
    //This is kinda wierd..
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    // Checking if I can change text color in code, since it doesn't work in Storyboard
    //    self.contentTextView.textColor = [UIColor redColor];
    // This doesn't work, color & font & all those sorts of things have to be changed in the Article
    // model with CSS
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // FB Shimmering Effect
    self.shimmerView.contentView = self.authorLabel;
    self.shimmerView.shimmering = YES;
    
    
   

    
   /*
    NSDictionary *options = @{
                              NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                              };
    */
    //NSMutableAttributedString
    
    /*
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithData:[self.article.content dataUsingEncoding:NSUTF32StringEncoding]
                                                                      options:options documentAttributes:nil
                                                                        error:nil];

     */
  /* NSDictionary* attributes = @{
                                 NSFontAttributeName:
                                     [UIFont fontWithName:@"Optima" size:18.0],};
    

    [attrString addAttributes:attributes range:NSMakeRange(0, [attrString length])];
   */
   // self.contentTextView.attributedText = self.article.attrContent;
    
   // self.contentTextView.attributedText = self.article.attrContent;

   //self.contentTextView.text = self.article.content;

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
