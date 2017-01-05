//
//  MySchoolDelegate.h
//  MySchool
//
//  Created by apple on 16/4/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SceneModel.h"

@protocol ScenePotocol

-(void)getScene:(SceneModel*)sceneModel;

@end

@protocol SceneLocationProtocol

-(void)getSceneLocationPoint:(double)latitude andLongitude:(double)longitude;
-(void)gotoGetLocationWithSceneModel:(SceneModel*)scene;

@end

@protocol SceneEditProtocol <NSObject>

-(void)gotoEditSceneModel:(SceneModel*)scene;

@end

@protocol ModifiySenceModelProtocol <NSObject>

-(void)modifySenceModel:(SceneModel*)sence;

@end

@interface MySchoolDelegate : NSObject



@end
