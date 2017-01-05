//
//  SceneViewController.m
//  MySchool
//
//  Created by apple on 16/2/18.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "AddSceneViewController.h"
#import "TitleTextField.h"
#import "SceneModel.h"
#import "ImageSize.h"
#import "Marco.h"
#import "NSUserDefaultHelper.h"
#import "MBProgressHUD.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>

#define SCHOOL @"school"


@interface AddSceneViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property(nonatomic,strong)NSData *imageData;
@property(nonatomic,strong)NSMutableArray *imageArr;
@property (retain, nonatomic)  TitleTextField *titleText;
@property (retain, nonatomic)  UITextView *introducation;
@property (retain, nonatomic)  TitleTextField *schoolArea;
@property(nonatomic,assign)int recommand;

@property(nonatomic,retain)UIButton *confirmBtn;
@property(nonatomic,retain)UIButton *cancelBtn;

@property(nonatomic,retain)SceneModel *editScene;
@property(nonatomic,copy)NSString *editSceneTitle;
@property(nonatomic,copy)NSString *editSceneIntroduction;

@property(nonatomic,assign)id<ModifiySenceModelProtocol>delegate;

@end

@implementation AddSceneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _imageArr = [[NSMutableArray alloc]init];
    _recommand = 0;
    
    [_backgroundImageView setUserInteractionEnabled:YES];
    
    UILabel *titlelabel     = [[UILabel alloc]initWithFrame:CGRectMake(20,
                                                                   SCREEN_HEIGHT * 0.3,
                                                                   42,
                                                                   21)];
    UILabel *locationLabel  = [[UILabel alloc]initWithFrame:CGRectMake(20,
                                                                      SCREEN_HEIGHT * 0.37,
                                                                      42,
                                                                      21)];
    
    titlelabel.font     = [UIFont boldSystemFontOfSize:17.0];
    locationLabel.font  = [UIFont boldSystemFontOfSize:17.0];
    
    titlelabel.text     = @"标题";
    locationLabel.text  = @"地点";
    
    [_backgroundImageView addSubview:titlelabel];
    [_backgroundImageView addSubview:locationLabel];
    
    _titleText = [[TitleTextField alloc]initWithFrame:CGRectMake(73,
                                                                 SCREEN_HEIGHT * 0.28,
                                                                 SCREEN_WIDTH-145,
                                                                 30)];
    _schoolArea = [[TitleTextField alloc]initWithFrame:CGRectMake(73,
                                                                  SCREEN_HEIGHT * 0.35,
                                                                  SCREEN_WIDTH-145,
                                                                  30)];
    
    _titleText.delegate     = self;
    _schoolArea.delegate    = self;
    
    _titleText.returnKeyType    = UIReturnKeyDone;
    _schoolArea.returnKeyType   = UIReturnKeyDone;
    
    _titleText.textAlignment    = NSTextAlignmentCenter;
    _schoolArea.textAlignment   = NSTextAlignmentCenter;
    
    _titleText.placeholder  = @"";
    _schoolArea.placeholder = @"校园地名";
    
    NSUserDefaults *userDefaults    = [NSUserDefaults standardUserDefaults];
    NSString *studentSchool         = [userDefaults objectForKey:SCHOOL];
    if (![studentSchool isEqualToString:@""])
    {
        _schoolArea.text = studentSchool;
    }
    
    _titleText.borderStyle  = UITextBorderStyleNone;
    _schoolArea.borderStyle = UITextBorderStyleNone;
    
    [_backgroundImageView addSubview:_titleText];
    [_backgroundImageView addSubview:_schoolArea];
    
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraBtn.frame     = CGRectMake(SCREEN_WIDTH * 0.82,
                                 SCREEN_HEIGHT * 0.28,
                                 41,
                                 37);
    
    [cameraBtn setBackgroundImage:[UIImage imageNamed:@"camera"]forState:UIControlStateNormal];
    
    [cameraBtn addTarget:self
                  action:@selector(addPhotos)
        forControlEvents:UIControlEventTouchUpInside];
    
    [_backgroundImageView addSubview:cameraBtn];
    
    UIImageView *pen = [[UIImageView alloc]initWithFrame:CGRectMake(29,
                                                                    SCREEN_HEIGHT * 0.45,
                                                                    25,
                                                                    22)];
    pen.image = [UIImage imageNamed:@"笔"];
    [_backgroundImageView addSubview:pen];
    
    UILabel *introduceLabel = [[UILabel alloc]initWithFrame:CGRectMake(73,
                                                                       SCREEN_HEIGHT * 0.448,
                                                                       55,
                                                                       22)];
    introduceLabel.font = [UIFont boldSystemFontOfSize:23.0];
    introduceLabel.text = @"简介";
    [_backgroundImageView addSubview:introduceLabel];
    
    _introducation = [[UITextView alloc]initWithFrame:CGRectMake(20,
                                                                 SCREEN_HEIGHT * 0.5,
                                                                 SCREEN_WIDTH * 0.85,
                                                                 SCREEN_HEIGHT * 0.3)];
    _introducation.backgroundColor = [UIColor clearColor];
    _introducation.layer.borderWidth = 1;
    _introducation.text = @"随便写点什么";
  //  _introducation.returnKeyType = UIReturnKeyDone; 不要完成，可能要换行编辑
    [_backgroundImageView addSubview:_introducation];
    
    UILabel *recommandLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 0.17,
                                                                       SCREEN_HEIGHT * 0.83,
                                                                       70,
                                                                       21)];
    recommandLabel.font = [UIFont systemFontOfSize:16.0];
    recommandLabel.text = @"推荐指数";
    [_backgroundImageView addSubview:recommandLabel];
    
    //判断是否是重新编辑
    if (_editScene != nil)
    {
        _titleText.text     = _editScene.title;
        _schoolArea.text    = _editScene.location;
        _introducation.text = _editScene.sendWord;
        
        for (int i = 0; i < _editScene.imagesArr.count; i++)
        {
            [_imageArr addObject:[_editScene.imagesArr objectAtIndex:i]];
        }
        
    }
    
    
    for (int i = 1; i < 6; i++)
    {
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame = CGRectMake(SCREEN_WIDTH * 0.3 + (i*25),
                                     SCREEN_HEIGHT * 0.83, 24, 22);
        
        [selectBtn setImage:[UIImage imageNamed:@"unselectstar"]
                   forState:UIControlStateNormal];
        
        [selectBtn setTag:i];
        [selectBtn addTarget:self
                      action:@selector(hasSelectedStarButton:)
            forControlEvents:UIControlEventTouchUpInside];
        
        [_backgroundImageView addSubview:selectBtn];
    }
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    _cancelBtn.frame = CGRectMake(SCREEN_WIDTH * 0.27,
                                 SCREEN_HEIGHT * 0.9,
                                 48,
                                 48);
    _confirmBtn.frame = CGRectMake(SCREEN_WIDTH * 0.62,
                                  SCREEN_HEIGHT * 0.9,
                                  48,
                                  48);

    [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"cha"]
                         forState:UIControlStateNormal];
    
    [_confirmBtn setBackgroundImage:[UIImage imageNamed:@"gou"]
                          forState:UIControlStateNormal];

    [_cancelBtn addTarget:self
                  action:@selector(cancelAdd)
        forControlEvents:UIControlEventTouchUpInside];
    
    [_confirmBtn addTarget:self
                   action:@selector(addSence)
         forControlEvents:UIControlEventTouchUpInside];

    [_backgroundImageView addSubview:_cancelBtn];
    [_backgroundImageView addSubview:_confirmBtn];
 
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showKeyboard:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideKeyboard:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
 //   [self searchTextViewWithView:self.view];
    
    [super viewWillAppear:YES];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

    if (_imageArr.count != 0)
    {
        UIScrollView* imageScrView = [[UIScrollView alloc]
                                      initWithFrame:CGRectMake(0,
                                                               0,
                                                               SCREEN_WIDTH,
                                                               SCREEN_HEIGHT/4)];
        
        imageScrView.contentSize = CGSizeMake(_imageArr.count * SCREEN_WIDTH,
                                              imageScrView.frame.size.height);
        imageScrView.pagingEnabled = YES;
        imageScrView.showsHorizontalScrollIndicator = NO;
        imageScrView.showsVerticalScrollIndicator = NO;
        for (int i = 0; i < _imageArr.count; i++)
        {
            
            UIImageView *sceneImageView = [[UIImageView alloc]
                                           initWithFrame:CGRectMake(SCREEN_WIDTH *i+4,
                                                                    0,
                                                                    SCREEN_WIDTH-8,
                                                                    imageScrView.frame.size.height)];
            sceneImageView.image =[_imageArr objectAtIndex:i];
            [imageScrView addSubview:sceneImageView];
        }
        
        [self.view addSubview:imageScrView];

    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    return YES;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_titleText resignFirstResponder];
    [_introducation resignFirstResponder];
    [_schoolArea resignFirstResponder];
}

- (void)searchTextViewWithView:(UIView *)view
{
        for (UIView *subview in view.subviews)
            {
                    if ([subview isKindOfClass:[UITextView class]]) {
                            ((UITextView *)subview).delegate = self;
                        }
                    if ([subview isKindOfClass:[UITextField class]]) {
                            ((UITextField *)subview).delegate = self;
                        }
                     [self searchTextViewWithView:subview];
                 }
    }

#pragma mark - 键盘躲避
- (void)showKeyboard:(NSNotification *)noti
{
    self.view.transform     = CGAffineTransformIdentity;
    UIView *editView        = _introducation;
    CGRect tfRect           = [editView.superview convertRect:editView.frame toView:self.view];
    NSValue *value          = noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect keyBoardF        = [value CGRectValue];
    CGFloat animationTime   = [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGFloat _editMaxY       = CGRectGetMaxY(tfRect);
    CGFloat _keyBoardMinY   = CGRectGetMinY(keyBoardF);
    
    if (_keyBoardMinY < _editMaxY) {
        CGFloat moveDistance = _editMaxY - _keyBoardMinY;
        [UIView animateWithDuration:animationTime animations:^{
            self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, -moveDistance);
        }];
    }
}
- (void)hideKeyboard:(NSNotification *)noti
{
    //	NSLog(@"%@", noti);
    self.view.transform = CGAffineTransformIdentity;
}

- (void)addPhotos {
    
#pragma 判断是否支持相机
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil
                                                                                  message: nil
                                                                           preferredStyle:UIAlertControllerStyleActionSheet];
        //添加Button
        [alertController addAction: [UIAlertAction actionWithTitle: @"拍照"
                                                             style: UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
            
            //处理点击拍照
            [self takePhoto];
                                                               
        }]];
        [alertController addAction: [UIAlertAction actionWithTitle: @"从相册选取"
                                                             style: UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action){
            //处理点击从相册选取
            [self getLocationPhotos];
            
        }]];
        [alertController addAction: [UIAlertAction actionWithTitle: @"取消"
                                                             style: UIAlertActionStyleCancel
                                                           handler:nil]];
        
        [self presentViewController: alertController animated: YES completion: nil];
        
    }
    
    else {
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil
                                                                                  message: nil
                                                                           preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction: [UIAlertAction actionWithTitle: @"从相册选取"
                                                             style: UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action){
            //处理点击从相册选取
            [self getLocationPhotos];
        }]];
        [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController: alertController animated: YES completion: nil];
        
    }
    
    
}

-(void)getLocationPhotos
{
    
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.maximumNumberOfSelection  = YES;
    imagePickerController.allowsMultipleSelection   = YES;
    imagePickerController.maximumNumberOfSelection  = 3;
    imagePickerController.minimumNumberOfSelection  = 1;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
    
}

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];

    UIImage *image             = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *compressImageData  = UIImageJPEGRepresentation(image, 0.00001);
    UIImage *finalImage        = [UIImage imageWithData:compressImageData];
    //获取view的尺寸而已,图片压缩后在10K～100K之间
    UIScrollView* imageScrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,
                                                                               0,
                                                                               SCREEN_WIDTH,
                                                                               SCREEN_HEIGHT/4)];
    
    UIImage *cutImage = [ImageSize cutImage:finalImage
                          andBackgroundView:imageScrView];
    
    [_imageArr addObject:cutImage];

}

#pragma mark - QBImagePickerControllerDelegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController
          didFinishPickingAssets:(NSArray *)assets
{
    
    [_imageArr removeAllObjects];

    PHImageManager *manager = [PHImageManager defaultManager];
    
    for (PHAsset *asset in assets)
    {
        [manager requestImageDataForAsset:asset
                                  options:nil
                            resultHandler:^(NSData * _Nullable imageData,
                                            NSString * _Nullable dataUTI,
                                            UIImageOrientation orientation,
                                            NSDictionary * _Nullable info)
         {
             UIImage *image             = [UIImage imageWithData:imageData];
             NSData *compressImageData  = UIImageJPEGRepresentation(image, 0.00001);
             UIImage *finalImage        = [UIImage imageWithData:compressImageData];
             //获取view的尺寸而已,图片压缩后在10K～100K之间
             UIScrollView* imageScrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,
                                                                                        0,
                                                                                        SCREEN_WIDTH,
                                                                                        SCREEN_HEIGHT/4)];

             UIImage *cutImage = [ImageSize cutImage:finalImage
                                   andBackgroundView:imageScrView];
             
            [_imageArr addObject:cutImage];
            
        }];
    }

    [self dismissViewControllerAnimated:YES completion:NULL];
    
}


- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"Canceled.");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (NSString *)descriptionForSelectingAllAssets:(QBImagePickerController *)imagePickerController
{
    return @"选择所有图片";
}

- (NSString *)descriptionForDeselectingAllAssets:(QBImagePickerController *)imagePickerController
{
    return @"取消选择所有";
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController
       descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos
{
    return [NSString stringWithFormat:@"共有照片%lu张", (unsigned long)numberOfPhotos];
}




-(void)hasSelectedStarButton:(UIButton*)sender
{
    int tag = (int)sender.tag;
    _recommand = tag;
    
    for (int i = 1; i <= tag; i++)
    {
        UIButton *selectbtn = (UIButton*)[self.view viewWithTag:i];
        
        [selectbtn setImage:[UIImage imageNamed:@"selectstar"]
                   forState:UIControlStateNormal];
    }
    
    for ( int i = tag+1; i <= 5; i++)
    {

        UIButton *unselectbtn = (UIButton*)[self.view viewWithTag:i];
        
        [unselectbtn setImage:[UIImage imageNamed:@"unselectstar"]
                     forState:UIControlStateNormal];
    }
    
}

- (void)cancelAdd {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addSence {
    
    
    if ([_titleText.text isEqualToString:@""])
    {
        UIAlertView *alterView  = [[UIAlertView alloc]init];
        alterView.title         = @"提示";
        alterView.message       = @"标题没填写，请填写标题";
        [alterView addButtonWithTitle:@"确定"];
        [alterView show];
        return;
    }
    else if ([_schoolArea.text isEqualToString:@""])
    {
        UIAlertView *alterView  = [[UIAlertView alloc]init];
        alterView.title         = @"提示";
        alterView.message       = @"地址没填写，请填写地址";
        [alterView addButtonWithTitle:@"确定"];
        [alterView show];
        return;
    }
    else if ([_introducation.text isEqualToString:@""])
    {
        UIAlertView *alterView  = [[UIAlertView alloc]init];
        alterView.title         = @"提示";
        alterView.message       = @"寄语没填写，请填写寄语";
        [alterView addButtonWithTitle:@"确定"];
        [alterView show];
        return;
    }
    else if (_imageArr.count == 0)
    {
        UIAlertView *alterView  = [[UIAlertView alloc]init];
        alterView.title         = @"提示";
        alterView.message       = @"请选择图片";
        [alterView addButtonWithTitle:@"确定"];
        [alterView show];
        return;
    }
    
    _confirmBtn.enabled = NO;
    _cancelBtn.enabled  = NO;
    
    MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide =YES;
    hud.mode            = MBProgressHUDModeText;
    hud.minSize         = CGSizeMake(60.f, 60.f);
    [hud hide:YES afterDelay:2];
    
    UIActivityIndicatorView *progressInd=[[UIActivityIndicatorView alloc]
                                          initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [progressInd startAnimating];
    progressInd.center = CGPointMake(hud.center.x, hud.center.y);
    [hud addSubview:progressInd];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString *time = [formatter stringFromDate:[NSDate new]];
    
    SceneModel *sceneModel = [[SceneModel alloc]init];
    
    sceneModel.title        = _titleText.text;
    sceneModel.location     = _schoolArea.text;
    sceneModel.sendWord     = _introducation.text;
    sceneModel.recommand    = [NSString stringWithFormat:@"%d",_recommand];
    
    for (int i = 0; i < _imageArr.count; i++)
    {
        [sceneModel.imagesArr addObject:[_imageArr objectAtIndex:i]];
    }
    sceneModel.time = time;    
    if (_editScene == nil)  //新增数据
    {
            [NSUserDefaultHelper addSenceModel:sceneModel];

    }
    else  //修改数据
    {
        _editScene = sceneModel;  //修改后重新赋值
        [NSUserDefaultHelper modifyInfoForSenceModel:sceneModel
                                        BySenceTitle:_editSceneTitle
                                andSenceIntroduction:_editSceneIntroduction];
        
    }
    //2.5后跳转，增强流畅性，用户体验
    [NSTimer scheduledTimerWithTimeInterval:2.5
                                     target:self
                                   selector:@selector(dissmisView)
                                   userInfo:nil
                                    repeats:NO];
}

-(void)dissmisView
{
    SceneViewController *senceVC = [self.storyboard
                                    instantiateViewControllerWithIdentifier:@"SceneViewController"];
    _delegate = (SceneViewController*)senceVC;
    [_delegate modifySenceModel:_editScene];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)gotoEditSceneModel:(SceneModel*)scene;
{
    _editScene = scene;
    _editSceneTitle = scene.title;
    _editSceneIntroduction = scene.sendWord;
}



@end
