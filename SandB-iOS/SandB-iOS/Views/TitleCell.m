//
//  TitleCell.m
//  SandB-iOS
//
//  Created by Lea Marolt on 4/11/14.
//  Copyright (c) 2014 Grinnell AppDev. All rights reserved.
//

#import "TitleCell.h"

@implementation TitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
