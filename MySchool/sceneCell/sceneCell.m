//
//  sceneCell.m
//  MySchool
//
//  Created by apple on 16/2/18.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "sceneCell.h"

@implementation sceneCell

- (void)awakeFromNib {
    
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        self.frame = CGRectMake(100, 0,280, 300);
        self.contentView.layer.borderWidth = 1;
        self.contentView.layer.cornerRadius = 14;
        self.contentView.layer.masksToBounds = YES;

    }
    
    return  self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
