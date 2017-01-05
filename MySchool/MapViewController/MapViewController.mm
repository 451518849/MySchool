//
//  MapViewController.m
//  MySchool
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "MapViewController.h"
#import "SceneViewController.h"
#import "SphereMenu.h"
#import "QRcodeViewController.h"
#import "SceneModel.h"
#import "Marco.h"
#import "MBProgressHUD.h"
#import "NSUserDefaultHelper.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件


#define ADDSENCETAG_1 101
#define ADDSENCETAG_2 102
#define ADDSENCETAG_3 103
#define ADDSENCETAG_4 104


@interface MapViewController ()<BMKMapViewDelegate,UIGestureRecognizerDelegate,BMKLocationServiceDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchResultsUpdating>
@property (nonatomic,retain) BMKMapView *mapView;
@property(nonatomic,retain)BMKLocationService *locService;
@property(nonatomic,retain)BMKPolyline *polyline;
@property(nonatomic,retain)SceneModel *scene;
@property(nonatomic,retain)id<ScenePotocol> delegate;
@property(nonatomic,assign)double nowLocationlatitude;
@property(nonatomic,assign)double nowLocationlongitude;
@property(nonatomic,assign)double sceneLocationlatitude;
@property(nonatomic,assign)double sceneLocationlongitude;
@property(nonatomic,assign)double bubbleLocationlongitude;
@property(nonatomic,assign)double bubbleLocationlatitude;
@property(nonatomic,copy)NSString *bubbleLocationPlacename;
@property(nonatomic,retain)BMKPointAnnotation *bubbleAnotation;

@property(nonatomic,retain)UISearchController *searchController;
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)UIView *bgView;
@property (nonatomic, strong) NSMutableArray *searchList;
@property (nonatomic, strong) NSMutableArray *dataList;

@property(nonatomic,assign)Boolean hasgottenLocation;

@end

@implementation MapViewController


-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    
    _locService.delegate    = self;
    _mapView.delegate       = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    
    _mapView.delegate       = nil; // 不用时，置nil
    _locService.delegate    = nil;
    
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    _nowLocationlatitude    = userLocation.location.coordinate.latitude;
    _nowLocationlongitude   = userLocation.location.coordinate.longitude;
    
    [_mapView updateLocationData:userLocation];
    
    if (_sceneLocationlatitude != 0.0 && _hasgottenLocation == NO)
    {
        //添加导航线段
        CLLocationCoordinate2D coors[2] = {0};
        coors[0].latitude   = _nowLocationlatitude;
        coors[0].longitude  = _nowLocationlongitude;
        coors[1].latitude   = _sceneLocationlatitude;
        coors[1].longitude  = _sceneLocationlongitude;
        //构建分段颜色索引数组
        NSArray *colorIndexs = [NSArray arrayWithObjects:
                                [NSNumber numberWithInt:0],
                                nil];
        _polyline = [BMKPolyline polylineWithCoordinates:coors count:2 textureIndex:colorIndexs];
        
        [_mapView addOverlay:_polyline];
        
        _hasgottenLocation = YES;
    }
    
 //   NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
}

//添加新坐标
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc]
                                                   initWithAnnotation:annotation
                                                   reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor      = BMKPinAnnotationColorRed;
        newAnnotationView.animatesDrop  = YES;// 设置该标注点动画显示
        newAnnotationView.draggable     = YES;
        
        //给跳转过来的景点添加新坐标
        if (_scene != nil && _nowLocationlatitude != 0.0)
        {
            
            [NSUserDefaultHelper addLocationInfoForSenceModel:_scene
                                                 withLatitude:_nowLocationlatitude
                                                 andLongitude:_nowLocationlongitude
                                                 andPlacename:_scene.location];
        }
        else
        {
            
            UIAlertView *alertView      = [[UIAlertView alloc]initWithTitle:@"地名"
                                                               message:@""
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                     otherButtonTitles:@"确定", nil];
            alertView.tag               = ADDSENCETAG_1;
            alertView.alertViewStyle    = UIAlertViewStylePlainTextInput;
            [alertView show];
        }
        
        return newAnnotationView;
    }
    return nil;
}

//选中气泡
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    CLLocationCoordinate2D coor     = view.annotation.coordinate;
    _bubbleLocationlatitude         = view.annotation.coordinate.latitude;
    _bubbleLocationlongitude        = view.annotation.coordinate.longitude;
    _bubbleLocationPlacename        = view.annotation.title;
    _bubbleAnotation                = view.annotation;
    
    if ([NSUserDefaultHelper isExsiToCoorLatitude:coor.latitude
                                     andLongitude:coor.longitude] != nil && _scene == nil && _sceneLocationlatitude == 0.0)
    {
                
        SceneViewController *sceneVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SceneViewController"];
        _delegate                    = (SceneViewController*)sceneVC;
        SceneModel *sceneData        = [NSUserDefaultHelper isExsiToCoorLatitude:coor.latitude
                                                             andLongitude:coor.longitude];
        [_delegate getScene:sceneData];
        [self.navigationController pushViewController:sceneVC animated:YES];
        
    }
    else if (_scene == nil && _sceneLocationlatitude == 0.0)
    {
        UIAlertView *alertView  = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"你想删除此坐标吗?"
                                                          delegate:self
                                                 cancelButtonTitle:@"不要"
                                                 otherButtonTitles:@"好的", nil];
        alertView.tag           = ADDSENCETAG_3;
        [alertView show];
 
    }
    else if(_scene.latitude.length == 0 && _sceneLocationlatitude == 0.0)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"确定坐标就在这里啦！"
                                                          delegate:self
                                                 cancelButtonTitle:@"在考虑下"
                                                 otherButtonTitles:@"好的", nil];
        alertView.tag          = ADDSENCETAG_4;
        [alertView show];

    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == ADDSENCETAG_1) {
        if (buttonIndex == 1)
        {
            //获取地名
            UITextField *placeName = [alertView textFieldAtIndex:0];
            
            [NSUserDefaultHelper addLocationInfoWithLatitude:_nowLocationlatitude
                                                andLongitude:_nowLocationlongitude
                                                andPlacename:placeName.text];
            MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText       = @"重新打开才更新数据哦";
            hud.removeFromSuperViewOnHide =YES;
            hud.mode            = MBProgressHUDModeText;
            hud.minSize         = CGSizeMake(60.f, 60.f);
            [hud hide:YES afterDelay:2.5];

        }
    }
    else if (alertView.tag == ADDSENCETAG_2)
    {
        if (buttonIndex == 1)
        {
            CLLocationCoordinate2D coor;
            BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
            coor.latitude   = _nowLocationlatitude;
            coor.longitude  = _nowLocationlongitude;
            annotation.coordinate = coor;
            [_mapView addAnnotation:annotation];

            MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText       = @"添加成功";
            hud.removeFromSuperViewOnHide =YES;
            hud.mode            = MBProgressHUDModeText;
            hud.minSize         = CGSizeMake(60.f, 60.f);
            [hud hide:YES afterDelay:1];
            
            _scene = nil;  //确定这只坐标后，不能重新添加
        }
    }
    else if (alertView.tag == ADDSENCETAG_3) //删除坐标活着添加新景点
    {
        if(buttonIndex == 1) //删除此坐标
        {
            
            [NSUserDefaultHelper deleteLcaotionInfoWithLatitude:_bubbleLocationlatitude
                                                   andLongitude:_bubbleLocationlongitude];
            [_mapView removeAnnotation:_bubbleAnotation];
            
            MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText       = @"删除成功";
            hud.removeFromSuperViewOnHide =YES;
            hud.mode            = MBProgressHUDModeText;
            hud.minSize         = CGSizeMake(60.f, 60.f);
            [hud hide:YES afterDelay:1];

        }

    }
    else if (alertView.tag == ADDSENCETAG_4) // 将景点设置在这
    {
        if(buttonIndex == 0) //不设置
        {
            
        }
        else if(buttonIndex == 1)//设置
        {
            [NSUserDefaultHelper addLocationInfoForSenceModel:_scene
                                                 withLatitude:_bubbleLocationlatitude
                                                 andLongitude:_bubbleLocationlongitude
                                                 andPlacename:_bubbleLocationPlacename];
            
            MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText       = @"定位成功";
            hud.removeFromSuperViewOnHide =YES;
            hud.mode            = MBProgressHUDModeText;
            hud.minSize         = CGSizeMake(60.f, 60.f);
            [hud hide:YES afterDelay:1];

            _scene.latitude = [NSString stringWithFormat:@"%f",_bubbleLocationlatitude];
        }

    }
}
//折线属性设置
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]){
        BMKPolylineView* polylineView   = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor        = [[UIColor purpleColor] colorWithAlphaComponent:1];
        polylineView.lineWidth          = 2.0;
        polylineView.colors             = [NSArray arrayWithObjects:[UIColor redColor], nil];  //折线颜色
        return polylineView;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"校园地图";
    
    if (!_scene && _sceneLocationlatitude == 0.0)
    {
        //导航栏右边的添加删除按钮
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"我要去"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(chooseLocation)];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0]}
                                                              forState:UIControlStateNormal];
    }

    _hasgottenLocation = NO;
    
    _dataList    = [[NSMutableArray alloc]init];
    _searchList  = [[NSMutableArray alloc]init];
    
    _tableView   = [[UITableView alloc]initWithFrame:CGRectMake(0,
                                                              0,
                                                              self.view.frame.size.width,
                                                              200)];
    _bgView      = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                      0,
                                                      SCREEN_HEIGHT,
                                                      SCREEN_WIDTH)];
    _searchController       = [[UISearchController alloc]initWithSearchResultsController:nil];
    
    _bgView.backgroundColor = [UIColor colorWithRed:140/255.0
                                              green:140/255.0
                                               blue:140/255.0
                                              alpha:1];
    
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,
                                                   self.searchController.searchBar.frame.origin.y,
                                                   self.searchController.searchBar.frame.size.width,
                                                   44.0);
    
    _searchController.searchResultsUpdater                  = self;
    _searchController.searchBar.delegate                    = self;
    _searchController.dimsBackgroundDuringPresentation      = YES;
    _searchController.hidesNavigationBarDuringPresentation  = NO;
    _tableView.tableHeaderView = _searchController.searchBar;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_bgView addSubview:_tableView];
    
    NSUserDefaults *userDefualts    = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *latitudeArr     = [userDefualts objectForKey:Latitudes];
    NSMutableArray *longitudeArr    = [userDefualts objectForKey:Longitudes];
    NSMutableArray *placenameArr    = [userDefualts objectForKey:Placenames];
    
    _mapView = [[BMKMapView alloc]init];
    _locService = [[BMKLocationService alloc]init];
    
    self.view = _mapView;
    
    //启动LocationService
    [_locService startUserLocationService];
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
    _mapView.zoomLevel = 18;
    
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isAccuracyCircleShow = NO; //去掉经度圈
    displayParam.isRotateAngleValid = YES;
    
    
    [_locService startUserLocationService];
    CLLocationCoordinate2D coor[latitudeArr.count];
    
    for (int i = 0; i < latitudeArr.count; i++)
    {
        BMKPointAnnotation* annotation  = [[BMKPointAnnotation alloc]init];
        coor[i].latitude                = [[latitudeArr objectAtIndex:i] doubleValue];
        coor[i].longitude               = [[longitudeArr objectAtIndex:i] doubleValue];
        annotation.coordinate           = coor[i];
        annotation.title                = [placenameArr objectAtIndex:i];
       [_mapView addAnnotation:annotation];
        
        [_dataList addObject:[placenameArr objectAtIndex:i]];
    }
    

    [_mapView updateLocationViewWithParam:displayParam];
    
    if (_sceneLocationlatitude == 0.0) //如果senceModel已经添加了坐标，则隐藏button
    {
        UIButton *addSenceBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
        addSenceBtn.frame       = CGRectMake(SCREEN_WIDTH-70,
                                             SCREEN_HEIGHT - 180,
                                             50,
                                             50);
        
        [addSenceBtn setBackgroundImage:[UIImage imageNamed:@"start"]forState:UIControlStateNormal];
        
        [addSenceBtn addTarget:self
                        action:@selector(addSenceAnnotation)
              forControlEvents:UIControlEventTouchUpInside];
        
        [_mapView addSubview:addSenceBtn];
    }

    //_tableView出来后，灰色背景
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    tap.delegate = self;
    [_bgView addGestureRecognizer:tap];
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isMemberOfClass:[_bgView class]]) {
        
        [_bgView removeFromSuperview];
        return YES;
    }else{
        return NO;
    }
    
}

-(void)addSenceAnnotation
{
    if(_scene){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"确定是这点坐标吗，设置后将无法改变"
                                                          delegate:self
                                                 cancelButtonTitle:@"在考虑下"
                                                 otherButtonTitles:@"确定", nil];
        alertView.tag = ADDSENCETAG_2;
        [alertView show];
    }
    else
    {
        
        CLLocationCoordinate2D coor;
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        coor.latitude   = _nowLocationlatitude;
        coor.longitude  = _nowLocationlongitude;
        annotation.coordinate = coor;
        [_mapView addAnnotation:annotation];

    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//关闭SearchBar
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_bgView removeFromSuperview];
}

//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.searchController.active) {
        return [self.searchList count];
    }else{
        return [self.dataList count];
    }
}

//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *flag=@"cellFlag";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:flag];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
    }
    if (self.searchController.active) {
        [cell.textLabel setText:self.searchList[indexPath.row]];
    }
    else{
        [cell.textLabel setText:self.dataList[indexPath.row]];
    }
    return cell;
}

//　具体调用的时候使用的方法也发生了改变，这个时候使用updateSearchResultsForSearchController进行结果过滤:
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [self.searchController.searchBar text];
    
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    //过滤数据
    self.searchList= [NSMutableArray arrayWithArray:[_dataList filteredArrayUsingPredicate:preicate]];
    //刷新表格
    [self.tableView reloadData];
}

//选中要去的地方
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    _searchController.searchBar.text = cell.textLabel.text;
    
    NSUserDefaults *userDefualts    = [NSUserDefaults standardUserDefaults];
    NSMutableArray *latitudeArr     = [NSMutableArray arrayWithArray:[userDefualts objectForKey:Latitudes]];
    NSMutableArray *longitudeArr    = [NSMutableArray arrayWithArray:[userDefualts objectForKey:Longitudes]];
    NSMutableArray *placenameArr    = [NSMutableArray arrayWithArray:[userDefualts objectForKey:Placenames]];
    
    for (int i = 0; i < placenameArr.count; i++)
    {
        if ([_searchController.searchBar.text isEqualToString:[placenameArr objectAtIndex:i]])
        {
            _sceneLocationlatitude  = [[latitudeArr objectAtIndex:i]doubleValue];
            _sceneLocationlongitude = [[longitudeArr objectAtIndex:i]doubleValue];
            
            //添加导航线段
            CLLocationCoordinate2D coors[2] = {0};
            coors[0].latitude   = _nowLocationlatitude;
            coors[0].longitude  = _nowLocationlongitude;
            coors[1].latitude   = _sceneLocationlatitude;
            coors[1].longitude  = _sceneLocationlongitude;
            //构建分段颜色索引数组
            NSArray *colorIndexs = [NSArray arrayWithObjects:
                                    [NSNumber numberWithInt:0],
                                    nil];
            [_mapView removeOverlay:_polyline];
            
            _polyline = [BMKPolyline polylineWithCoordinates:coors count:2 textureIndex:colorIndexs];
            
            [_mapView addOverlay:_polyline];
            
            _hasgottenLocation = YES;  //确保不重复添加路线
            break;
        }
    }
    [_bgView removeFromSuperview];
}

-(void)chooseLocation
{
    [_mapView addSubview:_bgView];
}

//获取SceneViewController传过来的坐标
-(void)getSceneLocationPoint:(double)latitude andLongitude:(double)longitude;
{
    
    _sceneLocationlatitude  = latitude;
    _sceneLocationlongitude = longitude;
}
//获取SceneViewController传过来的实例
-(void)gotoGetLocationWithSceneModel:(SceneModel*)scene;
{
    _scene = scene;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

