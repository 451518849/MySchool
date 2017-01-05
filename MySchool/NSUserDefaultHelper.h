//
//  NSUserDefaultHelper.h
//  MySchool
//
//  Created by apple on 16/3/31.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SceneModel.h"
@interface NSUserDefaultHelper : NSObject

/**************************************** 初始化 **********************************************/
/*******************************************************************************************/

/*
 * 初始化SenceModel数组
 *
 */
+(NSMutableArray*)initWithSenceModelArray;

/**************************************** 新增 **********************************************/
/*******************************************************************************************/

/*
 *  新增景点
 *  @prama sence
 */
+(void)addSenceModel:(SceneModel*)sence;

/*
 *  给景点添加的坐标
 *  @prama senceModel   景点
 *  @prama latitude     经度
 *  @prama longitude    纬度
 *  @prama longitude    地名
 */
+(void)addLocationInfoForSenceModel:(SceneModel*)senceModel
                       withLatitude:(double)latitude
                       andLongitude:(double)longitude
                       andPlacename:(NSString*)placename;

/*
 *  给景点添加的坐标
 *  @prama senceModel   景点
 *  @prama latitude     经度
 *  @prama longitude    纬度
 *  @prama longitude    地名
 */
//+(void)addSenceForLocationWith:(do)
/*
 *  存储新添加的坐标
 *  @prama latitude     经度
 *  @prama longitude    纬度
 *  @prama longitude    地名
 */
+(void)addLocationInfoWithLatitude:(double)latitude
                      andLongitude:(double)longitude
                      andPlacename:(NSString*)placename;

/*************************************** 删除 ************************************************/
/*******************************************************************************************/

/*
 *  删除坐标
 *  @prama latitude     经度
 *  @prama longitude    纬度
 */
+(void)deleteLcaotionInfoWithLatitude:(double)latitude
                         andLongitude:(double)longitude;

/***************************************** 判断 *********************************************/
/*******************************************************************************************/


/*
 *  判断数据库中是否已经存有数据
 */
+(BOOL)hasSavedLocationScence;

/*
 *  判断坐标是否已经存在与数据库
 *  @prama latitude     经度
 *  @prama longitude    纬度
 */
+(SceneModel*)isExsiToCoorLatitude:(double)latitude
                      andLongitude:(double)longitude;

/******************************************* 修改 *******************************************/
/*******************************************************************************************/

/*
 *  修改景点的数据
 *  @prama sence            修改的景点
 *  @prama title            景点名称
 *  @prama introduction     景点的简介
 */
+(void)modifyInfoForSenceModel:(SceneModel*)sceneModel
                  BySenceTitle:(NSString*)title
          andSenceIntroduction:(NSString*)introduction;
@end
