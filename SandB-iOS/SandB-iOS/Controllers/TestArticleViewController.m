//
//  TestViewController.m
//  SandB-iOS
//
//  Created by Maijid Moujaled on 12/24/13.
//  Copyright (c) 2013 Grinnell AppDev. All rights reserved.
//

#import "TestArticleViewController.h"

@interface TestArticleViewController ()
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

@end

@implementation TestArticleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.testLabel.text = self.article.title;
    
    //This is kinda wierd..
   
    
    NSDictionary *options = @{
                              NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                              };
    
    //NSMutableAttributedString
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithData:[self.article.content dataUsingEncoding:NSUTF32StringEncoding]
                                                                      options:options documentAttributes:nil
                                                                        error:nil];

  /* NSDictionary* attributes = @{
                                 NSFontAttributeName:
                                     [UIFont fontWithName:@"Optima" size:18.0],};
    

    [attrString addAttributes:attributes range:NSMakeRange(0, [attrString length])];
   */
    self.contentTextView.attributedText = attrString;
    

   // self.contentTextView.text = self.article.content;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
