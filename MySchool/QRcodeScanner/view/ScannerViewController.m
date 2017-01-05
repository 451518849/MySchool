//
//  ScannerViewController.m
//  MySchool
//
//  Created by apple on 16/2/24.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "ScannerViewController.h"

#define Height [UIScreen mainScreen].bounds.size.height
#define Width [UIScreen mainScreen].bounds.size.width
#define XCenter self.view.center.x
#define YCenter self.view.center.y

#define SHeight 20

#define SWidth (XCenter+30)


#define Latitudes @"alllatitudes"
#define Longitudes @"alllongitudes"
#define Placenames @"allplacenames"

@interface ScannerViewController ()
{
    UIImageView * imageView;
}

@end

@implementation ScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"扫一扫";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(0,0, 290, 50)];
    labIntroudction.center = CGPointMake(self.view.frame.size.width/2, 100);
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"请将其它用户的二维码放入其中扫描,就能分享到其它用户的地图啦";
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labIntroudction];
    
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake((Width-SWidth)/2,(Height-SWidth)/2,SWidth,SWidth)];
    imageView.image = [UIImage imageNamed:@"scanscanBg.png"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame)+5, CGRectGetMinY(imageView.frame)+5, SWidth-10,1)];
    _line.image = [UIImage imageNamed:@"scanLine@2x.png"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setupCamera];
}
-(void)viewWillDisappear:(BOOL)animated
{
    
}
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(CGRectGetMinX(imageView.frame)+5, CGRectGetMinY(imageView.frame)+5+2*num, SWidth-10,1);
        
        if (num ==(int)(( SWidth-10)/2)) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame =CGRectMake(CGRectGetMinX(imageView.frame)+5, CGRectGetMinY(imageView.frame)+5+2*num, SWidth-10,1);
        
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}


- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    _output.rectOfInterest =[self rectOfInterestByScanViewRect:imageView.frame];//CGRectMake(0.1, 0, 0.9, 1);//
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode];
    
    
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResize;
    _preview.frame =self.view.bounds;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    [self.view bringSubviewToFront:imageView];
    
    [self setOverView];
    
    // Start
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        /**
         *  获取扫描结果
         */
        stringValue = metadataObject.stringValue;
        
        if ([stringValue isEqualToString:@"noMap"])
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"对方暂时没有地图可分享"preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [_session startRunning];
            }]];
            [self presentViewController:alert animated:true completion:nil];
            
            [_session stopRunning];
            return;
        }
        
        //处理扫描的结果
        NSArray *stringvalueArr = [stringValue componentsSeparatedByString:@","];
        int stringArrlength = (int)stringvalueArr.count - 1;
        int averageLength = stringArrlength/3;
        
        NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];

        NSMutableArray *latitudeArr = [userDefualts objectForKey:Latitudes];
        NSMutableArray *longitudeArr = [userDefualts objectForKey:Longitudes];
        NSMutableArray *placenameArr = [userDefualts objectForKey:Placenames];

        if (latitudeArr.count == 0)
        {
            //创建坐标信息数组
            latitudeArr = [[NSMutableArray alloc]init];
            longitudeArr = [[NSMutableArray alloc]init];
            placenameArr = [[NSMutableArray alloc]init];

        }
        
        for (int i = 0; i<averageLength; i++)
        {
            [latitudeArr addObject:[stringvalueArr objectAtIndex:i]];
        }
        for (int i = averageLength; i<2*averageLength; i++)
        {
            [longitudeArr addObject:[stringvalueArr objectAtIndex:i] ];
        }
        for (int i = 2*averageLength; i<3*averageLength; i++)
        {
            [placenameArr addObject:[stringvalueArr objectAtIndex:i]];
        }
        
        [userDefualts setObject:latitudeArr forKey:Latitudes];
        [userDefualts setObject:longitudeArr forKey:Longitudes];
        [userDefualts setObject:placenameArr forKey:Placenames];

    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"地图获取成功！"preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [_session startRunning];
    }]];
    [self presentViewController:alert animated:true completion:nil];
    
    
    [_session stopRunning];
    //    [self dismissViewControllerAnimated:YES completion:^
    //     {
    //         [timer invalidate];
    //
    //     }];
    
    
    
}

- (CGRect)rectOfInterestByScanViewRect:(CGRect)rect {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    CGFloat x = (height - CGRectGetHeight(rect)) / 2 / height;
    CGFloat y = (width - CGRectGetWidth(rect)) / 2 / width;
    
    CGFloat w = CGRectGetHeight(rect) / height;
    CGFloat h = CGRectGetWidth(rect) / width;
    
    return CGRectMake(x, y, w, h);
}

#pragma mark - 添加模糊效果
- (void)setOverView {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    CGFloat x = CGRectGetMinX(imageView.frame);
    CGFloat y = CGRectGetMinY(imageView.frame);
    CGFloat w = CGRectGetWidth(imageView.frame);
    CGFloat h = CGRectGetHeight(imageView.frame);
    
    [self creatView:CGRectMake(0, 0, width, y)];
    [self creatView:CGRectMake(0, y, x, h)];
    [self creatView:CGRectMake(0, y + h, width, height - y - h)];
    [self creatView:CGRectMake(x + w, y, width - x - w, h)];
}

- (void)creatView:(CGRect)rect {
    CGFloat alpha = 0.5;
    UIColor *backColor = [UIColor grayColor];
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = backColor;
    view.alpha = alpha;
    [self.view addSubview:view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
