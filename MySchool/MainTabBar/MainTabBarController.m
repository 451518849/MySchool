//
//  MainTabBarController.m
//  MySchool
//
//  Created by apple on 16/2/18.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "MainTabBarController.h"
#import "AddSceneViewController.h"
@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.tabBar.backgroundColor     = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    
    UIButton *centerButton          = [UIButton buttonWithType:UIButtonTypeCustom];
    centerButton.backgroundColor    = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [centerButton setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [centerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [centerButton addTarget:self action:@selector(addScene) forControlEvents:UIControlEventTouchUpInside];
    centerButton.frame              = CGRectMake(0, 0, 50, 50);
    centerButton.layer.borderWidth  = 1;
    centerButton.layer.borderColor  = [UIColor blackColor].CGColor;
    centerButton.layer.cornerRadius = 25;

    centerButton.center = CGPointMake(self.tabBar.center.x, self.tabBar.center.y - 22.5);
    
    [self.view addSubview:centerButton];
    
}

-(void)addScene
{
    AddSceneViewController *sceneVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddSceneViewController"];
    [self presentViewController:sceneVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
