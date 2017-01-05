//
//  ViewController.m
//  MySchool
//
//  Created by apple on 16/2/18.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "ViewController.h"
#import "SceneViewController.h"
#import "sceneCell.h"
#import "ImageSize.h"
#import "MBProgressHUD.h"
#import "SJAvatarBrowser.h"
#import "welecomeView.h"
#import "Marco.h"
#import "NSUserDefaultHelper.h"

@interface ViewController ()
@property(nonatomic,strong)UITableView *mainSceneTable;
@property(nonatomic,assign)id<ScenePotocol> delegate;
@property(nonatomic,strong)NSMutableArray *decodedSceneModels;
@property(nonatomic,assign)int sceneTag;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated;
{
    //初始化所有数据
    _decodedSceneModels = [NSUserDefaultHelper initWithSenceModelArray];
        
    [_mainSceneTable reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sceneTag = 200; //设置sceneImageview的初始tag值
    
    _mainSceneTable = [[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   SCREEN_WIDTH,
                                                                   SCREEN_HEIGHT)];
    _mainSceneTable.backgroundColor     = [UIColor clearColor];
    
    _mainSceneTable.backgroundView      = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"花.jpg"]];
    _mainSceneTable.delegate    = self;
    _mainSceneTable.dataSource  = self;
    
    
    [self.view addSubview:_mainSceneTable];
    [self setExtraFooterHidden:_mainSceneTable];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setExtraFooterHidden:(UITableView*)tableView
{
    UIView *view                = [[UIView alloc]init];
    view.backgroundColor        = [UIColor clearColor];
    tableView.tableFooterView   = view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return _decodedSceneModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return  320;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 40;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView          = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _mainSceneTable.frame.size.width, 40)];
    footerView.backgroundColor  = [UIColor clearColor];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellIdentifier = @"senceCell";

    UITableViewCell *cell           = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  //  cell.backgroundColor = [UIColor clearColor];
    
    
    //从model中选选数据
    SceneModel *sceneData       = [_decodedSceneModels objectAtIndex:indexPath.section];
    UIView *cellBackgroundView  = [[UIView alloc]initWithFrame:CGRectMake(20,
                                                                         10,
                                                                         SCREEN_WIDTH-45,
                                                                         300)];

    cellBackgroundView.layer.borderWidth    = 1;
    cellBackgroundView.layer.cornerRadius   = 5;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,
                                                                   5,
                                                                   SCREEN_WIDTH-45,
                                                                   20)];
    titleLabel.text                 = sceneData.title;
    titleLabel.textAlignment        = NSTextAlignmentCenter;
    
    //图片轮滑
    UIScrollView *imageScrView      = [[UIScrollView alloc]initWithFrame:CGRectMake(0,
                                                                               25,
                                                                               SCREEN_WIDTH-45,
                                                                               170)];
    imageScrView.backgroundColor    = [UIColor blackColor];
    imageScrView.contentSize        = CGSizeMake(sceneData.imagesArr.count * (SCREEN_WIDTH-45), 160);
    imageScrView.pagingEnabled      = YES;
    imageScrView.showsHorizontalScrollIndicator = NO;
    imageScrView.showsVerticalScrollIndicator   = NO;
    
    [cellBackgroundView addSubview:imageScrView];
    
    for (int i = 0; i < sceneData.imagesArr.count; i++)
    {
        UIImageView *sceneImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-45)*i,
                                                                                   5,
                                                                                   SCREEN_WIDTH-45,
                                                                                   160)];
        UIImage *image = [ImageSize cutImage:[sceneData.imagesArr objectAtIndex:i]
                           andBackgroundView:imageScrView];
        
        sceneImageView.tag                    = _sceneTag;
        _sceneTag++;
        sceneImageView.image                  = image;
        sceneImageView.userInteractionEnabled = YES; //允许点击
        [imageScrView addSubview:sceneImageView];
        UITapGestureRecognizer *tap           = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                             action:@selector(magnifyImage:)];
        [sceneImageView addGestureRecognizer:tap];
    }

    
    UILabel *sendWordTitle      = [[UILabel alloc]initWithFrame:CGRectMake(10,
                                                                      200,
                                                                      40,
                                                                      40)];
    sendWordTitle.font = [UIFont systemFontOfSize:20.0f weight:2];
    sendWordTitle.text = @"简介";
    sendWordTitle.textColor     = [UIColor blackColor];
    
    UILabel *sendeWordContent   = [[UILabel alloc]initWithFrame:CGRectMake(10,
                                                                         240,
                                                                         SCREEN_WIDTH-80,
                                                                         40)];
    sendeWordContent.numberOfLines  = 2;
    sendeWordContent.font           = [UIFont systemFontOfSize:13.0f];
    sendeWordContent.textColor      = [UIColor blackColor];
    sendeWordContent.text           = sceneData.sendWord;
    
    UIImageView *mapIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"地图.png"]];
    mapIcon.frame = CGRectMake(SCREEN_WIDTH-120,
                               280,
                               8,
                               13);
    
    for (int j = 1; j <= [sceneData.recommand intValue]; j++)
    {
        UIImageView *selectStar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"selectstar.png"]];
        selectStar.frame = CGRectMake(SCREEN_WIDTH-120 + j*10,
                                      220,
                                      10,
                                      10);
        [cellBackgroundView addSubview:selectStar];
    }
    
    UILabel *recommad           = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-170,
                                                                 215,
                                                                 80,
                                                                 20)];
    recommad.text = @"推荐指数";
    recommad.font = [UIFont systemFontOfSize:13.0];
    
    for (int k = 1 ; k <= 5 -[sceneData.recommand intValue]; k++)
    {
        UIImageView *unselectStar   = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"unselectstar.png"]];
        unselectStar.frame          = CGRectMake(SCREEN_WIDTH-120 + [sceneData.recommand intValue]*10 + k * 10,
                                        220,
                                        10,
                                        10);
        [cellBackgroundView addSubview:unselectStar];

    }
    
    UILabel *schoolArea            = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-110,
                                                                   282,
                                                                   150,
                                                                   10)];
    schoolArea.text = sceneData.location;
    schoolArea.font = [UIFont systemFontOfSize:10];
    
    UILabel *time   = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-95,
                                                             315,
                                                             80,
                                                             10)];
    time.text = sceneData.time;
    time.font = [UIFont systemFontOfSize:14.0];

    [cellBackgroundView addSubview:titleLabel];
    [cellBackgroundView addSubview:recommad];
    [cellBackgroundView addSubview:sendWordTitle];
    [cellBackgroundView addSubview:imageScrView];
    [cellBackgroundView addSubview:sendeWordContent];
    [cellBackgroundView addSubview:mapIcon];
    [cellBackgroundView addSubview:schoolArea];
    [cell addSubview:cellBackgroundView];
    [cell addSubview:time];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    SceneViewController *sceneVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SceneViewController"];
    
    _delegate                    = (SceneViewController*)sceneVC;
    SceneModel *sceneData        = [_decodedSceneModels objectAtIndex:indexPath.section];
    [_delegate getScene:sceneData];
    
    [self.navigationController pushViewController:sceneVC animated:YES];
    
}

-(void)magnifyImage:(UIGestureRecognizer*)tap
{
    UIImageView *imageView = [self.view viewWithTag:[tap view].tag];
    [SJAvatarBrowser showImage:imageView];
}

-(void)getScene:(SceneModel*)sceneModel;
{
    
}
@end
