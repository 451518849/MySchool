//
//  ApplicationViewController.m
//  MySchool
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "ApplicationViewController.h"
#import "MyInfoViewController.h"
#import "MapViewController.h"
#import "QRcodeViewController.h"
#import "ScannerViewController.h"
#import <StoreKit/StoreKit.h>

@interface ApplicationViewController ()<UITableViewDataSource,UITableViewDelegate,SKStoreProductViewControllerDelegate>

@property (retain, nonatomic) UITableView *applicationTableView;

@end

@implementation ApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    _applicationTableView                   = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 300)];
    _applicationTableView.backgroundColor   =  [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    _applicationTableView.delegate      = self;
    _applicationTableView.dataSource    = self;
    
    [self.view addSubview:_applicationTableView];
    [self setExtraCellLineHidden:_applicationTableView];
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
}

-(void)setExtraCellLineHidden:(UITableView*)tableView
{
    UIView *view            = [UIView new];
    view.backgroundColor    = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [tableView setTableFooterView:view];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellIdentifier = @"icell";
    UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row == 0)
    {
        cell.imageView.image    = [UIImage imageNamed:@"my.png"];
        cell.textLabel.text     = @" 我的信息";
        cell.textLabel.font     = [UIFont systemFontOfSize:14.0];
    }
    else if (indexPath.row == 1)
    {
        cell.imageView.image    = [UIImage imageNamed:@"schoolmap.png"];
        cell.textLabel.text     = @"校园地图";
        cell.textLabel.font     = [UIFont systemFontOfSize:14.0];
    }
    else if (indexPath.row == 2)
    {
        cell.imageView.image    = [UIImage imageNamed:@"sharemap.png"];
        cell.textLabel.text     = @"分享地图";
        cell.textLabel.font     = [UIFont systemFontOfSize:14.0];
    }
    else if (indexPath.row == 3)
    {
        cell.imageView.image    = [UIImage imageNamed:@"saoma.png"];
        cell.textLabel.text     = @" 扫 一 扫";
        cell.textLabel.font     = [UIFont systemFontOfSize:14.0];
    }
    else if (indexPath.row == 4)
    {
        cell.imageView.image    = [UIImage imageNamed:@"comment.png"];
        cell.textLabel.text     = @"用户反馈";
        cell.textLabel.font     = [UIFont systemFontOfSize:14.0];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0)
    {
        MyInfoViewController *myInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyInfoViewController"];
        [self.navigationController pushViewController:myInfoVC animated:YES];
    }
    else if (indexPath.row == 1)
    {
        MapViewController *mapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
        [self.navigationController pushViewController:mapVC animated:YES];
    }
    else if (indexPath.row == 2)
    {
        QRcodeViewController *qrVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QRcodeViewController"];
        [self.navigationController pushViewController:qrVC animated:YES];
  
    }
    else if (indexPath.row == 3)
    {
        ScannerViewController *scVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ScannerViewController"];
        [self.navigationController pushViewController:scVC animated:YES];
    }
    else
    {
        NSString *str2 = [NSString stringWithFormat:
                          @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",
                          @"1099438232"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str2]];
    }
    
    
}


//暂时无法使用
-(void)gotoAppstoretoEvaluate
{
    //初始化控制器
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
    //设置代理请求为当前控制器本身
    storeProductViewContorller.delegate = self;
    //加载一个新的视图展示
    [storeProductViewContorller loadProductWithParameters:
     //appId唯一的
     @{SKStoreProductParameterITunesItemIdentifier : @"1078527356"} completionBlock:^(BOOL result, NSError *error) {
         //block回调
         if(error){
             NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
         }else{
             //模态弹出appstore
             [self presentViewController:storeProductViewContorller animated:YES completion:^{
                 
             }
              ];
         }
     }];

}


//取消按钮监听
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
