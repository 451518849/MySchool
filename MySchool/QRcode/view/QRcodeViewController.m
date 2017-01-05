//
//  QRcodeViewController.m
//  MySchool
//
//  Created by apple on 16/2/24.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "QRcodeViewController.h"
#import "QRCodeGenerator.h"

#define Latitudes @"alllatitudes"
#define Longitudes @"alllongitudes"
#define Placenames @"allplacenames"


@interface QRcodeViewController ()

@end

@implementation QRcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分享地图";
    
//    double latitudeArr[100]  = {32.091213,32.087200,32.085110,32.082882,32.082184,32.081173};
//    double longitudeArr[100] = {118.644039,118.643188,118.646461,118.647476,118.649590,118.650543};
//    NSArray *distinction = [[NSArray alloc]initWithObjects:@"同和",@"北苑食堂",@"东苑宿舍",@"东苑食堂",@"生物与制药工程学院",@"大礼堂", nil];
//    
    NSString *latitudeAppendingStr = @"";
    NSString *longutiteAppendingStr = @"";
    NSString *placenameArrAppendingStr = @"";
    
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *latitudeArr = [userDefualts objectForKey:Latitudes];
    NSMutableArray *longitudeArr = [userDefualts objectForKey:Longitudes];
    NSMutableArray *placenameArr = [userDefualts objectForKey:Placenames];

//
    if (latitudeArr.count == 0)
    {
        latitudeAppendingStr = @"noMap";
    }
    
    for (int i = 0; i < latitudeArr.count; i++)
    {
        latitudeAppendingStr = [latitudeAppendingStr stringByAppendingString:[NSString stringWithFormat:@"%@,",[latitudeArr objectAtIndex:i]]];
        longutiteAppendingStr = [longutiteAppendingStr stringByAppendingString:[NSString stringWithFormat:@"%@,",[longitudeArr objectAtIndex:i]]];
        placenameArrAppendingStr = [placenameArrAppendingStr stringByAppendingString:[NSString stringWithFormat:@"%@,",placenameArr[i]]];

    }
    
    latitudeAppendingStr = [latitudeAppendingStr stringByAppendingString:longutiteAppendingStr];
    latitudeAppendingStr = [latitudeAppendingStr stringByAppendingString:placenameArrAppendingStr];
    
//    NSLog(@"%@",latitudeAppendingStr);
//    
//    NSArray *arr = [latitudeAppendingStr componentsSeparatedByString:@","];
//    NSLog(@"%@",arr);
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    imageView.center = CGPointMake(self.view.center.x, self.view.center.y-100);
    imageView.image = [QRCodeGenerator qrImageForString:latitudeAppendingStr imageSize:imageView.bounds.size.width];
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 250, 20)];
    label.center = CGPointMake(self.view.frame.size.width/2, self.view.center.y + imageView.frame.size.height/2-100);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"扫一扫二维码就能分享地图啦";
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
