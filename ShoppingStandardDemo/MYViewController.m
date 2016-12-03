//
//  MYViewController.m
//  ShoppingStandardDemo
//
//  Created by Wangjc on 16/3/5.
//  Copyright © 2016年 Wangjc. All rights reserved.
//

#import "MYViewController.h"
#import "StandardsView.h"
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#ifndef DLog
#define DLog(fmt,...) NSLog((@"%s [Line %d] " fmt),__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__)
#endif
@interface MYViewController ()<StandardsViewDelegate>

@end

@implementation MYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    backBtn.backgroundColor = [UIColor redColor];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backBtn];
    
    self.view.contentMode = UIViewContentModeCenter;
    self.view.backgroundColor = [UIColor blueColor];
    //    [[UIScreen mainScreen] bounds].size.width
    
    UIButton *tempBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT - 100, 60, 44)];
    tempBtn1.tag = 0;
    [tempBtn1 setImage:[UIImage imageNamed:@"gril"] forState:UIControlStateNormal];
    [tempBtn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tempBtn1];
    
    UIButton *tempBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(tempBtn1.frame.size.width+tempBtn1.frame.origin.x + 10, SCREEN_HEIGHT - 100, 60, 44)];
    tempBtn2.tag = 1;
    [tempBtn2 setImage:[UIImage imageNamed:@"butterfly"] forState:UIControlStateNormal];
    [tempBtn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tempBtn2];
    
    UIButton *tempBtn3 = [[UIButton alloc] initWithFrame:CGRectMake(tempBtn2.frame.size.width+tempBtn2.frame.origin.x + 10, SCREEN_HEIGHT - 100, 60, 44)];
    tempBtn3.tag = 2;
    [tempBtn3 setImage:[UIImage imageNamed:@"yellowBee"] forState:UIControlStateNormal];
    [tempBtn3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tempBtn3];

    // Do any additional setup after loading the view.
}

-(void)backBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)btnClick:(UIButton *)sender
{
    
    StandardsView *mystandardsView = [self buildStandardView:sender.imageView.image andIndex:sender.tag];
    mystandardsView.GoodDetailView = self.view;//设置该属性 对应的view 会缩小
    
    switch (sender.tag) {
        case 0:
        {
            mystandardsView.showAnimationType = StandsViewShowAnimationShowFrombelow;
            mystandardsView.dismissAnimationType = StandsViewDismissAnimationDisFrombelow;
        }
            break;
        case 1:
        {
            mystandardsView.showAnimationType = StandsViewShowAnimationFlash;
            mystandardsView.dismissAnimationType = StandsViewDismissAnimationFlash;
        }
            break;
        case 2:
        {
            mystandardsView.showAnimationType = StandsViewShowAnimationShowFromLeft;
            mystandardsView.dismissAnimationType = StandsViewDismissAnimationDisToRight;
        }
            break;
        default:
            break;
    }
    
    [mystandardsView show];
    
}

-(StandardsView *)buildStandardView:(UIImage *)img andIndex:(NSInteger)index
{
    StandardsView *standview = [[StandardsView alloc] init];
    standview.tag = index;
    standview.delegate = self;
    
    standview.mainImgView.image = img;
    standview.mainImgView.backgroundColor = [UIColor whiteColor];
    standview.priceLab.text = @"¥100.0";
    standview.tipLab.text = @"请选择规格";
    standview.goodNum.text = @"库存 10件";
    
    
    standview.customBtns = @[@"加入购物车",@"立即购买"];
    
    
    standardClassInfo *tempClassInfo1 = [standardClassInfo StandardClassInfoWith:@"100" andStandClassName:@"红色"];
    standardClassInfo *tempClassInfo2 = [standardClassInfo StandardClassInfoWith:@"101" andStandClassName:@"蓝色"];
    NSArray *tempClassInfoArr = @[tempClassInfo1,tempClassInfo2];
    StandardModel *tempModel = [StandardModel StandardModelWith:tempClassInfoArr andStandName:@"颜色"];
    
    
    
    standardClassInfo *tempClassInfo3 = [standardClassInfo StandardClassInfoWith:@"102" andStandClassName:@"XL"];
    standardClassInfo *tempClassInfo4 = [standardClassInfo StandardClassInfoWith:@"103" andStandClassName:@"XXL"];
    standardClassInfo *tempClassInfo5 = [standardClassInfo StandardClassInfoWith:@"104" andStandClassName:@"XXXXXXXXXXXXXL"];
    NSArray *tempClassInfoArr2 = @[tempClassInfo3,tempClassInfo4,tempClassInfo5];
    StandardModel *tempModel2 = [StandardModel StandardModelWith:tempClassInfoArr2 andStandName:@"尺寸"];
    standview.standardArr = @[tempModel,tempModel2];
    
    
    
    return standview;
}

#pragma mark - standardView  delegate
//点击自定义按键
-(void)StandardsView:(StandardsView *)standardView CustomBtnClickAction:(UIButton *)sender
{
    if (sender.tag == 0) {
        //将商品图片抛到指定点
        [standardView ThrowGoodTo:CGPointMake(200, 100) andDuration:1.6 andHeight:150 andScale:20];
    }
    else
    {
        [standardView dismiss];
    }
}

//点击规格代理
-(void)Standards:(StandardsView *)standardView SelectBtnClick:(UIButton *)sender andSelectID:(NSString *)selectID andStandName:(NSString *)standName andIndex:(NSInteger)index
{
    
    DLog(@"selectID = %@ standName = %@ index = %ld",selectID,standName,(long)index);
    
}
//设置自定义btn的属性
-(void)StandardsView:(StandardsView *)standardView SetBtn:(UIButton *)btn
{
    if (btn.tag == 0) {
        btn.backgroundColor = [UIColor yellowColor];
    }
    else if (btn.tag == 1)
    {
        btn.backgroundColor = [UIColor orangeColor];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com