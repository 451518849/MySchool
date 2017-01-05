//
//  QRCodeGenerator.h
//  MySchool
//
//  Created by apple on 16/2/24.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QRCodeGenerator : NSObject
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size;
@end
