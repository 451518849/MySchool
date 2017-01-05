//
//  ImageSize.m
//  MySchool
//
//  Created by apple on 16/2/27.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "ImageSize.h"

@implementation ImageSize

//裁剪图片
+(UIImage *)cutImage:(UIImage*)image andBackgroundView:(UIView*)_headerView
{
    //压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;
    
    if ((image.size.width / image.size.height) < (_headerView.frame.size.width / _headerView.frame.size.height)) {
        newSize.width = image.size.width;
        newSize.height = image.size.width * _headerView.frame.size.height / _headerView.frame.size.width;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
        
    } else {
        newSize.height = image.size.height;
        newSize.width = image.size.height * _headerView.frame.size.width / _headerView.frame.size.height;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
        
    }
    
    return [UIImage imageWithCGImage:imageRef];
}

@end

