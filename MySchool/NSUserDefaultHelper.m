//
//  NSUserDefaultHelper.m
//  MySchool
//
//  Created by apple on 16/3/31.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "NSUserDefaultHelper.h"
#import "Marco.h"

@implementation NSUserDefaultHelper

+(NSMutableArray*)initWithSenceModelArray;
{
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    NSData *savedEncodedSceneModels = [userDefualts objectForKey:SENCEMODELS_KEY];

    if (savedEncodedSceneModels != nil)
    {
        
        NSMutableArray *decodeSenceModels = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:savedEncodedSceneModels];
        return decodeSenceModels;
    }
    else
    {
        return nil;
    }
}

+(void)addSenceModel:(SceneModel*)sence;
{
    NSUserDefaults *userDefualts    = [NSUserDefaults standardUserDefaults];
    NSData *savedEncodedSceneModels = [userDefualts objectForKey:SENCEMODELS_KEY];

    if (savedEncodedSceneModels == nil)
    {
        NSMutableArray *sceneModels = [[NSMutableArray alloc]init];
        [sceneModels addObject:sence];
        NSData *encodedSceneModels = [NSKeyedArchiver archivedDataWithRootObject:sceneModels];
        [userDefualts setObject:encodedSceneModels forKey:SENCEMODELS_KEY];
    }
    else
    {
        NSMutableArray *decodedSceneModels = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:savedEncodedSceneModels];
        [decodedSceneModels addObject:sence];
        
        NSData *encodedSceneModels = [NSKeyedArchiver archivedDataWithRootObject:decodedSceneModels];
        [userDefualts setObject:encodedSceneModels forKey:SENCEMODELS_KEY];
    }

}

+(void)addLocationInfoForSenceModel:(SceneModel*)sence
                       withLatitude:(double)latitude
                       andLongitude:(double)longitude
                       andPlacename:(NSString*)placename;
{
    sence.latitude =[NSString stringWithFormat:@"%f",latitude];
    sence.longitude = [NSString stringWithFormat:@"%f",longitude];
    
    NSUserDefaults *userDefualts    = [NSUserDefaults standardUserDefaults];
    NSMutableArray *latitudeArr     = [NSMutableArray arrayWithArray:[userDefualts objectForKey:Latitudes]];
    NSMutableArray *longitudeArr    = [NSMutableArray arrayWithArray:[userDefualts objectForKey:Longitudes]];
    NSMutableArray *placenameArr    = [NSMutableArray arrayWithArray:[userDefualts objectForKey:Placenames]];
    
    if (latitudeArr.count == 0)
    {
        //创建坐标信息数组
        latitudeArr     = [[NSMutableArray alloc]init];
        longitudeArr    = [[NSMutableArray alloc]init];
        placenameArr    = [[NSMutableArray alloc]init];
        
    }
    
    BOOL hasExsitLocation = NO;  //标注是否已经存在
    
    for (NSString *latitude in latitudeArr)
    {
        if ([latitude isEqualToString:sence.latitude])
        {
            hasExsitLocation = YES;
            break;
        }
    }
    
    if (!hasExsitLocation) //不存在则添加进去
    {
        
        [latitudeArr addObject:[NSString stringWithFormat:@"%f",latitude]];
        [longitudeArr addObject:[NSString stringWithFormat:@"%f",longitude]];
        [placenameArr addObject:sence.location];

        
        [userDefualts setObject:latitudeArr forKey:Latitudes];
        [userDefualts setObject:longitudeArr forKey:Longitudes];
        [userDefualts setObject:placenameArr forKey:Placenames];
    }
    

    
    NSData *savedEncodedSceneModels     = [userDefualts objectForKey:SENCEMODELS_KEY];
    NSMutableArray *decodedSceneModels  = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:savedEncodedSceneModels];
    for (int i = 0; i < decodedSceneModels.count; i++)
    {
        SceneModel *sceneModel = [decodedSceneModels objectAtIndex:i];
        if ([ sceneModel.time isEqualToString:sence.time])
        {
            [decodedSceneModels replaceObjectAtIndex:i withObject:sence];
            NSData *encodedSceneModels = [NSKeyedArchiver archivedDataWithRootObject:decodedSceneModels];
            [userDefualts setObject:encodedSceneModels forKey:SENCEMODELS_KEY];
            break;
        }
        
    }
}

+(void)addLocationInfoWithLatitude:(double)latitude
                      andLongitude:(double)longitude
                     andPlacename:(NSString*)placename;
{
    NSUserDefaults *userDefualts    = [NSUserDefaults standardUserDefaults];
    NSMutableArray *latitudeArr     = [NSMutableArray arrayWithArray:[userDefualts objectForKey:Latitudes]];
    NSMutableArray *longitudeArr    = [NSMutableArray arrayWithArray:[userDefualts objectForKey:Longitudes]];
    NSMutableArray *placenameArr    = [NSMutableArray arrayWithArray:[userDefualts objectForKey:Placenames]];
    
    if (latitudeArr.count == 0)  //如果没创建过，就重新创建数组
    {
        //创建坐标信息数组
        latitudeArr     = [[NSMutableArray alloc]init];
        longitudeArr    = [[NSMutableArray alloc]init];
        placenameArr    = [[NSMutableArray alloc]init];
        
    }
    [latitudeArr addObject:[NSString stringWithFormat:@"%f",latitude]];
    [longitudeArr addObject:[NSString stringWithFormat:@"%f",longitude]];
    [placenameArr addObject:placename];
    
    [userDefualts setObject:latitudeArr forKey:Latitudes];
    [userDefualts setObject:longitudeArr forKey:Longitudes];
    [userDefualts setObject:placenameArr forKey:Placenames];
}

+(void)deleteLcaotionInfoWithLatitude:(double)latitude
                         andLongitude:(double)longitude;
{
    NSUserDefaults *userDefualts    = [NSUserDefaults standardUserDefaults];
    NSMutableArray *latitudeArr     = [NSMutableArray arrayWithArray:[userDefualts objectForKey:Latitudes]];
    NSMutableArray *longitudeArr    = [NSMutableArray arrayWithArray:[userDefualts objectForKey:Longitudes]];
    NSMutableArray *placenameArr    = [NSMutableArray arrayWithArray:[userDefualts objectForKey:Placenames]];
    
    for (int i = 0 ; i < latitudeArr.count; i++) {
        
        if ([[latitudeArr objectAtIndex:i]doubleValue] == latitude &&
            [[longitudeArr objectAtIndex:i]doubleValue] == longitude) {
            
            [latitudeArr removeObjectAtIndex:i];
            [longitudeArr removeObjectAtIndex:i];
            [placenameArr removeObjectAtIndex:i];
            break;
        }
    }
    //  删除完毕后在存储起来
    [userDefualts setObject:latitudeArr forKey:Latitudes];
    [userDefualts setObject:longitudeArr forKey:Longitudes];
    [userDefualts setObject:placenameArr forKey:Placenames];

}

+(BOOL)hasSavedLocationScence;
{
    NSUserDefaults *userDefualts    = [NSUserDefaults standardUserDefaults];
    NSData *savedEncodedSceneModels = [userDefualts objectForKey:SENCEMODELS_KEY];
    if (savedEncodedSceneModels != nil) {
        return YES;
    }
    return NO;
}

+(SceneModel*)isExsiToCoorLatitude:(double)latitude
                      andLongitude:(double)longitude;
{
    NSUserDefaults *userDefualts        = [NSUserDefaults standardUserDefaults];
    NSData *savedEncodedSceneModels     = [userDefualts objectForKey:SENCEMODELS_KEY];
    NSMutableArray *decodedSceneModels  = [[NSMutableArray alloc]init];
    
    decodedSceneModels = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:savedEncodedSceneModels];
    for (int j = 0; j < decodedSceneModels.count; j++)
    {
        SceneModel *scene =[decodedSceneModels objectAtIndex:j];
        if (latitude == [scene.latitude doubleValue] && longitude == [scene.longitude doubleValue])
        {
            
            return [decodedSceneModels objectAtIndex:j];
            break;
        }
    }
    return nil;
}

+(void)modifyInfoForSenceModel:(SceneModel*)sceneModel
                  BySenceTitle:(NSString*)title
          andSenceIntroduction:(NSString*)introduction;
{
    NSUserDefaults *userDefualts        = [NSUserDefaults standardUserDefaults];
    NSData *savedEncodedSceneModels     = [userDefualts objectForKey:SENCEMODELS_KEY];

    NSMutableArray *decodedSceneModels  = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:savedEncodedSceneModels];
    
    for (SceneModel *scene in decodedSceneModels)
    {
        if ([scene.sendWord isEqualToString:introduction] && [scene.title isEqualToString:title])
        {
            [decodedSceneModels removeObject:scene]; //直接将要修改的数据删除，然后在添加新的数据
            break;
        }
    }
    
    [decodedSceneModels addObject:sceneModel];
    
    NSData *encodedSceneModels = [NSKeyedArchiver archivedDataWithRootObject:decodedSceneModels];
    [userDefualts setObject:encodedSceneModels forKey:SENCEMODELS_KEY];

}

@end











