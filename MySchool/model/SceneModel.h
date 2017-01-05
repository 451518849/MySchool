//
//  SceneModel.h
//  MySchool
//
//  Created by apple on 16/2/19.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <UIKit/UIKit.h>

@interface SceneModel : NSObject <NSCoding>  //将自定义model转化成NSData数据类型

@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *location;
@property(nonatomic,copy)NSString *sendWord;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString *latitude;
@property(nonatomic,copy)NSString *longitude;
@property(nonatomic,copy)NSString *recommand;
@property(nonatomic,strong)NSMutableArray *imagesArr;
 
@end


