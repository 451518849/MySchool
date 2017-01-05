//
//  SceneViewController.m
//  MySchool
//
//  Created by apple on 16/2/19.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "SceneViewController.h"
#import "SceneModel.h"
#import "MapViewController.h"
#import "MBProgressHUD.h"
#import "ImageSize.h"
#import "Marco.h"
#import "SJAvatarBrowser.h"
#import "AddSceneViewController.h"

@interface SceneViewController ()<UIAlertViewDelegate>
@property(nonatomic,strong)SceneModel *sceneModel;
@property (retain, nonatomic)  UIScrollView *imageScrView;
@property (retain, nonatomic)  UITextView *sendWord;
@property (retain, nonatomic)  UIImageView *locationImage;
@property (retain, nonatomic)  UIButton *MapBtn;
@property (retain, nonatomic)  UIImageView *recommandStarImage;
@property (retain, nonatomic)  UIImageView *mapicon;
@property (retain, nonatomic)  UILabel *recommad;
@property (retain, nonatomic)  UILabel *location;
@property (retain, nonatomic)  UILabel *time;
@property(nonatomic,assign)int sceneTag;
@property(nonatomic,assign)BOOL hadLoaded;

@property (retain, nonatomic)  id<SceneLocationProtocol> locationDelegate;
@property (retain, nonatomic)  id<SceneEditProtocol> editDelegate;

@end

@implementation SceneViewController



- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    
    if (!_hadLoaded)
    {
    self.title = _sceneModel.title;
    _sceneTag = 200;
    //导航栏右边的添加删除按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(deleteScene)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0]}
                                                          forState:UIControlStateNormal];
        
        //滚动图片
    UIScrollView *backScrView   = [[UIScrollView alloc]
                                 initWithFrame:CGRectMake(0,
                                                          0,
                                                          SCREEN_WIDTH,
                                                          SCREEN_HEIGHT)];
    backScrView.contentSize     = CGSizeMake(SCREEN_WIDTH,
                                         SCREEN_HEIGHT+100);
        
    backScrView.showsHorizontalScrollIndicator = YES;
    backScrView.showsVerticalScrollIndicator = NO;
    
    UIImageView *backImage      = [[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          SCREEN_WIDTH,
                                                                          SCREEN_HEIGHT)];
    backImage.image = [UIImage imageNamed:@"花.png"];
    [backScrView addSubview:backImage];
    
    _imageScrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,
                                                                  10,
                                                                  SCREEN_WIDTH,
                                                                  SCREEN_HEIGHT/3+40)];
    _imageScrView.backgroundColor   = [UIColor blackColor];
    _imageScrView.contentSize       = CGSizeMake(_sceneModel.imagesArr.count * SCREEN_WIDTH,
                                           _imageScrView.frame.size.height);
    _imageScrView.pagingEnabled = YES;
    _imageScrView.showsHorizontalScrollIndicator    = NO;
    _imageScrView.showsVerticalScrollIndicator      = NO;
    
    for (int i = 0; i < _sceneModel.imagesArr.count; i++)
    {
        UIImageView *sceneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH *i+4,
                                                                                   10,
                                                                                   SCREEN_WIDTH-8,
                                                                                   _imageScrView.frame.size.height-20)];
        sceneImageView.image = [ImageSize cutImage:[_sceneModel.imagesArr objectAtIndex:i]
                                 andBackgroundView:_imageScrView];
        
        [_imageScrView addSubview:sceneImageView];
        sceneImageView.tag = _sceneTag;
        _sceneTag++;
        sceneImageView.userInteractionEnabled = YES; //允许点击
        [_imageScrView addSubview:sceneImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(magnifyImage:)];
        
        [sceneImageView addGestureRecognizer:tap];

    }

    _locationImage = [[UIImageView alloc]initWithFrame:CGRectMake(25,
                                                                  SCREEN_HEIGHT/3+67,
                                                                  10,
                                                                  16)];
    _locationImage.image = [UIImage imageNamed:@"tolocation.png"];
    
    _MapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _MapBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    _MapBtn.frame = CGRectMake(20,
                               SCREEN_HEIGHT/3+60,
                               100,
                               30);
    [_MapBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_MapBtn setTitle:@"去看看" forState:UIControlStateNormal];
        
    [_MapBtn addTarget:self
                action:@selector(gotoSceneLocation)
      forControlEvents:UIControlEventTouchUpInside];
    
    _sendWord = [[UITextView alloc]initWithFrame:CGRectMake(20,
                                                            SCREEN_HEIGHT/3+90,
                                                            SCREEN_WIDTH-50,
                                                            100)];
    _sendWord.editable = NO;
    _sendWord.text = _sceneModel.sendWord;
        
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake(SCREEN_WIDTH-50,
                                  SCREEN_HEIGHT/3+160,
                                  20,
                                  17);
    [editButton setImage:[UIImage imageNamed:@"笔"] forState:UIControlStateNormal];
        
    [editButton addTarget:self
                   action:@selector(editScene)
         forControlEvents:UIControlEventTouchUpInside];
        
    _recommad = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-150,
                                                         SCREEN_HEIGHT/3+190,
                                                         80,
                                                         20)];
    _recommad.font = [UIFont systemFontOfSize:13.0f];
    _recommad.text = @"推荐指数";
    
    for (int j = 1; j <=[_sceneModel.recommand intValue]; j++)
    {
        UIImageView *selectStar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"selectstar.png"]];
        selectStar.frame = CGRectMake(SCREEN_WIDTH-95 + j*12,
                                      SCREEN_HEIGHT/3+195,
                                      10,
                                      10);
        
        [backScrView addSubview:selectStar];
    }
    
    for (int k = 1 ; k <= 5 - [_sceneModel.recommand intValue]; k++)
    {
        UIImageView *unselectStar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"unselectstar.png"]];
        unselectStar.frame = CGRectMake(SCREEN_WIDTH-95 + [_sceneModel.recommand intValue]*12 + k * 12,
                                        SCREEN_HEIGHT/3+195,
                                        10,
                                        10);
        
        [backScrView addSubview:unselectStar];
        
    }

    
    _mapicon = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-115,
                                                            SCREEN_HEIGHT/3+235,
                                                            8,
                                                            12)];
    _mapicon.image = [UIImage imageNamed:@"地图.png"];
    
    _location = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100,
                                                         SCREEN_HEIGHT/3+230,
                                                         120,
                                                         20)];
    _location.font = [UIFont systemFontOfSize:12.0f];
    _location.text = _sceneModel.location;
    
    
    _time = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100,
                                                     SCREEN_HEIGHT/3+250,
                                                     100,
                                                     20)];
    _time.font = [UIFont systemFontOfSize:14.0f];
    _time.text = _sceneModel.time;
 
    [self.view addSubview:backScrView];
    [backScrView addSubview:_imageScrView];
    [backScrView addSubview:_locationImage];
    [backScrView addSubview:_MapBtn];
    [backScrView addSubview:_sendWord];
    [backScrView addSubview:editButton];
    [backScrView addSubview:_recommad];
    [backScrView addSubview:_mapicon];
    [backScrView addSubview:_location];
    [backScrView addSubview:_time];
        
        _hadLoaded = YES;
    }
}

-(void)magnifyImage:(UIGestureRecognizer*)tap
{
    UIImageView *imageView = [self.view viewWithTag:[tap view].tag];
    [SJAvatarBrowser showImage:imageView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _hadLoaded = NO; //防止页面重新出来的时候被加载两次，viewappear 里
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide =YES;
    hud.mode = MBProgressHUDModeText;
    hud.minSize = CGSizeMake(60.f, 60.f);
    
    [hud hide:YES afterDelay:2];
    
    UIActivityIndicatorView *progressInd=[[UIActivityIndicatorView alloc]
                                          initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [progressInd startAnimating];
    progressInd.center = CGPointMake(hud.center.x, hud.center.y-30);

    [hud addSubview:progressInd];
    
}

-(void)gotoSceneLocation
{
    if ([_sceneModel.latitude isEqualToString:@""] && [_sceneModel.longitude isEqualToString:@""])
    {
        NSLog(@"latitude:%@",_sceneModel.latitude);
        NSLog(@"latitude:%@",_sceneModel.longitude);

        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"这个景点还没有在地图上定位哦"
                                                          delegate:nil
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"去定位", nil];
        [alertView show];
        alertView.tag = 100;
        alertView.delegate = self;
        return;
    }
    else
    {
        MapViewController *mapVC = [self.storyboard
                                    instantiateViewControllerWithIdentifier:@"MapViewController"];
        _locationDelegate = (MapViewController*)mapVC;
        [_locationDelegate getSceneLocationPoint:[_sceneModel.latitude doubleValue]
                                    andLongitude:[_sceneModel.longitude doubleValue]];
        [self.navigationController pushViewController:mapVC animated:YES];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        
        if (buttonIndex == 1)
        {
            MapViewController *mapVC = [self.storyboard
                                        instantiateViewControllerWithIdentifier:@"MapViewController"];
            _locationDelegate = (MapViewController*)mapVC;
            [_locationDelegate gotoGetLocationWithSceneModel:_sceneModel];
            [self.navigationController pushViewController:mapVC animated:YES];
            
        }

    }
    if (alertView.tag == 101)
    {
        if (buttonIndex == 0)
        {
            
            NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
            NSMutableArray *decodedSceneModels = [[NSMutableArray alloc]init];
            NSData *savedEncodedSceneModels = [userDefualts objectForKey:@"sceneModels"];
            
            if (savedEncodedSceneModels != nil)
            {
                decodedSceneModels = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:savedEncodedSceneModels];
            }
            
            for (SceneModel *scene in decodedSceneModels)
            {
                if ( [scene.sendWord isEqual:_sceneModel.sendWord] && [scene.title isEqual:_sceneModel.title])
                {
                    [decodedSceneModels removeObject:scene];
                    
                    NSData *encodedSceneModels = [NSKeyedArchiver archivedDataWithRootObject:decodedSceneModels];
                    [userDefualts setObject:encodedSceneModels forKey:@"sceneModels"];
                    
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.labelText = @"删除中...";
                    hud.removeFromSuperViewOnHide =YES;
                    hud.mode = MBProgressHUDModeText;
                    hud.minSize = CGSizeMake(60.f, 60.f);
                    [hud hide:YES afterDelay:2];
                    
                    UIActivityIndicatorView *progressInd=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:
                                                                                        UIActivityIndicatorViewStyleWhiteLarge];
                    [progressInd startAnimating];
                    progressInd.center = CGPointMake(hud.center.x, hud.center.y);
                    
                    [hud addSubview:progressInd];

                    [NSTimer scheduledTimerWithTimeInterval:3.0
                                                     target:self
                                                   selector:@selector(poptoView)
                                                   userInfo:nil
                                                    repeats:NO];
                    
                    break;
                }
            }
        }
    }
}

-(void)poptoView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//编辑
-(void)editScene
{
    AddSceneViewController *addVC = [self.storyboard
                                     instantiateViewControllerWithIdentifier:@"AddSceneViewController"];
    
    _editDelegate = (AddSceneViewController*)addVC;
    [_editDelegate gotoEditSceneModel:_sceneModel];
    [self presentViewController:addVC animated:YES completion:nil];
}

//删除
-(void)deleteScene
{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"确定删除"
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:@"取消",
                                                                nil];
    alertView.delegate  = self;
    alertView.tag       = 101;
    [alertView show];

}

-(void)getScene:(SceneModel*)sceneModel;
{
    _sceneModel = sceneModel;
}

-(void)modifySenceModel:(SceneModel*)sence;
{
    _sceneModel = sence;
}

@end
