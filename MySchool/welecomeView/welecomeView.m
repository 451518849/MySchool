//
//  welecomeView.m
//  MySchool
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "welecomeView.h"
#import "Marco.h"
@implementation WelecomeView

{
    UIScrollView *welecomeSrcView;
    UIPageControl *pageControl;
    UIButton *disapperBtn;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        welecomeSrcView   = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        welecomeSrcView.pagingEnabled   = YES;
        welecomeSrcView.delegate        = self;
        welecomeSrcView.showsVerticalScrollIndicator    = NO;
        welecomeSrcView.showsHorizontalScrollIndicator  = NO;
        welecomeSrcView.contentSize                     = CGSizeMake(SCREEN_WIDTH*3,SCREEN_HEIGHT);
        
        pageControl                        = [[UIPageControl alloc]init];
        pageControl.center                 = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-200);
        pageControl.numberOfPages          = 3;
        pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        pageControl.currentPage = 0;
        
        _welecomeImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                                       0 ,
                                                                       SCREEN_WIDTH,
                                                                       SCREEN_HEIGHT)];
        
        _welecomeImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH,
                                                                       0,
                                                                       SCREEN_WIDTH,
                                                                       SCREEN_HEIGHT)];
        
        _welecomeImage3 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 2 ,
                                                                       0,
                                                                       SCREEN_WIDTH,
                                                                       SCREEN_HEIGHT)];
        
        _welecomeImage1.image = [UIImage imageNamed:@"first"];
        _welecomeImage2.image = [UIImage imageNamed:@"second"];
        _welecomeImage3.image = [UIImage imageNamed:@"third"];

        [welecomeSrcView addSubview:_welecomeImage1];
        [welecomeSrcView addSubview:_welecomeImage2];
        [welecomeSrcView addSubview:_welecomeImage3];
        
        [self addSubview:welecomeSrcView];
        [self addSubview:pageControl];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 250, 30)];
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 250, 30)];
        UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 250, 30)];
        UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 250, 30)];

        label1.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        label2.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        label3.center = CGPointMake(SCREEN_WIDTH/2, 60);
        label4.center = CGPointMake(SCREEN_WIDTH/2-20, SCREEN_HEIGHT-80);

        label1.text = @"点击中间按钮来添加地点介绍";
        label2.text = @"点击“去看看”立即定位到地图上";
        label3.text = @"点击可查找已经定位的地点-->";
        label4.text = @"点击可在地图上添加新坐标-->";

        label1.textColor = [UIColor whiteColor];
        label2.textColor = [UIColor whiteColor];
        label3.textColor = [UIColor whiteColor];
        label4.textColor = [UIColor whiteColor];

        UIView *frontView1 = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                     0 ,
                                                                     SCREEN_WIDTH,
                                                                     SCREEN_HEIGHT)];
        
        UIView *frontView2 = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      0 ,
                                                                      SCREEN_WIDTH,
                                                                      SCREEN_HEIGHT)];
        
        UIView *frontView3 = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      0 ,
                                                                      SCREEN_WIDTH,
                                                                      SCREEN_HEIGHT)];

        frontView1.alpha = 0.8;
        frontView2.alpha = 0.8;
        frontView3.alpha = 0.8;

        frontView1.backgroundColor = [UIColor blackColor];
        frontView2.backgroundColor = [UIColor blackColor];
        frontView3.backgroundColor = [UIColor blackColor];

        [frontView1 addSubview:label1];
        [frontView2 addSubview:label2];
        [frontView3 addSubview:label3];
        [frontView3 addSubview:label4];
        
        
        [_welecomeImage1 addSubview:frontView1];
        [_welecomeImage2 addSubview:frontView2];
        [_welecomeImage3 addSubview:frontView3];

        UIImageView *gesture1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-20,
                                                                             SCREEN_HEIGHT-80,
                                                                             60,
                                                                             78)];
        UIImageView *gesture2 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-100,
                                                                             SCREEN_HEIGHT/2+20,
                                                                             60,
                                                                             78)];
        UIImageView *gesture3 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50,
                                                                             40,
                                                                             60,
                                                                             78)];
        UIImageView *gesture4 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80,
                                                                             SCREEN_HEIGHT-80,
                                                                             60,
                                                                             78)];

        gesture1.image = [UIImage imageNamed:@"gesture"];
        gesture2.image = [UIImage imageNamed:@"gesture"];
        gesture3.image = [UIImage imageNamed:@"gesture"];
        gesture4.image = [UIImage imageNamed:@"gesture"];

        [frontView1 addSubview:gesture1];
        [frontView2 addSubview:gesture2];
        [frontView3 addSubview:gesture3];
        [frontView3 addSubview:gesture4];

        
        disapperBtn             = [UIButton buttonWithType:UIButtonTypeCustom];
        disapperBtn.frame       = CGRectMake(SCREEN_WIDTH/2, SCREEN_WIDTH/2, 100, 30);
        disapperBtn.center      = CGPointMake(self.center.x*5, self.center.y);
        disapperBtn.layer.cornerRadius = 15;
        disapperBtn.layer.borderWidth   = 1;
        disapperBtn.layer.borderColor   = [UIColor whiteColor].CGColor;
        
        [disapperBtn setTitle:@"知道咯" forState:UIControlStateNormal];
        frontView3.userInteractionEnabled = YES;
        frontView1.userInteractionEnabled = YES;
        [disapperBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [disapperBtn addTarget:self
                        action:@selector(disappearWelecomeView)
              forControlEvents:UIControlEventTouchUpInside];
        
        [welecomeSrcView addSubview:disapperBtn];

    }
    
    return self;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/scrollView.frame.size.width;
    if (page == 0) {
        pageControl.currentPage = 0;
    }
    else if (page == 1)
    {
        pageControl.currentPage = 1;
    }
    else if (page == 2)
    {
        pageControl.currentPage = 2;
    }
}

-(void)disappearWelecomeView
{
    [UIView animateWithDuration:2.0 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
