//
//  TitleTextField.m
//  MySchool
//
//  Created by apple on 16/2/18.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "TitleTextField.h"

@implementation TitleTextField

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1].CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5));

}

@end
