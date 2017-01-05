//
//  AppDelegate.m
//  MySchool
//
//  Created by apple on 16/2/18.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "AppDelegate.h"
#import "welecomeView/welecomeView.h"
#import "Marco.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSUserDefaults *userdefaults    = [NSUserDefaults standardUserDefaults];
    NSString *firstComming          = [userdefaults objectForKey:@"welcome"];
    if (firstComming.length == 0)
    {
        WelecomeView *welcomeView   = [[WelecomeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_window.rootViewController.view addSubview:welcomeView];
        [userdefaults setObject:@"1" forKey:@"welcome"];
    }

        
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    UINavigationBar *bar    = [UINavigationBar appearance];
    bar.translucent         = NO;
    bar.barTintColor        = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:0.1];
    bar.tintColor           = [UIColor whiteColor];//左边的leftitembutton颜色
    bar.titleTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:14.0],NSForegroundColorAttributeName: [UIColor whiteColor]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} forState:0];
    
    BMKMapManager* _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定 generalDelegate参数
    BOOL ret = [_mapManager start:@"IdoBGEfhPbRp8e6NZ32OCeRV"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    // Add the navigation controller's view to the window and display.
    // [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
