//
//  SceneViewController.h
//  MySchool
//
//  Created by apple on 16/2/18.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBImagePickerController.h"
#import "SceneViewController.h"
#import "MySchoolDelegate.h"

@interface AddSceneViewController : UIViewController<UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,QBImagePickerControllerDelegate,UITextViewDelegate,SceneEditProtocol>

@end
