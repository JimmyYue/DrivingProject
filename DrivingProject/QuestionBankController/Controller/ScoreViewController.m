//
//  ScoreViewController.m
//  SZPageControllerDemo
//
//  Created by JimmyYue on 2021/2/20.
//  Copyright © 2021 StenpZ. All rights reserved.
//

#import "ScoreViewController.h"

@interface ScoreViewController ()

@end

@implementation ScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"模拟考试";
    
    if ([self.correctCount integerValue] > 89) {
        [self.view.layer insertSublayer:self.gradientLayerS atIndex:1];
    } else {
        [self.view.layer insertSublayer:self.gradientLayer atIndex:1];
    }
    
    self.scoreTopView = [[NSBundle mainBundle] loadNibNamed:@"ScoreTopView" owner:nil options:nil][0];
    self.scoreTopView.frame = CGRectMake(0, StatusRect + NavRect + 10, kDeviceWidth, 480);
    [self.view addSubview:self.scoreTopView];
    
    int usreTime = 60 * 45 - self.count;
    int minutes = usreTime / 60;
    int seconds = usreTime % 60;
    NSString *strTime = [NSString stringWithFormat:@"用时 : %d:%.2d",minutes, seconds];
    self.scoreTopView.timeLabel.text = strTime;
    
    if ([self.correctCount integerValue] > 89) {
        self.scoreTopView.qualifiedLabel.text = @"合格";
    }
    
    [self.scoreTopView.autoCalculateCircleView drawCircleWithPercent:[self.correctCount integerValue]
                               duration:2
                              lineWidth:15
                              clockwise:YES
                                lineCap:kCALineCapRound
                              fillColor:[UIColor clearColor]
                            strokeColor:[UIColor whiteColor]
                         animatedColors:nil];
    self.scoreTopView.autoCalculateCircleView.percentLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:45];
    self.scoreTopView.autoCalculateCircleView.percentLabel.textColor = [UIColor whiteColor];
    [self.scoreTopView.autoCalculateCircleView startAnimation];
    
    self.scoreTopView.errorLabel.text = [NSString stringWithFormat:@"答错%@题，未做%ld题", self.errorCount, 100 - [self.errorCount integerValue] - [self.correctCount integerValue]];
    
    [self.scoreTopView.errorBtn addTarget:self action:@selector(errorBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scoreTopView.againBtn addTarget:self action:@selector(againBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[XYCommon GetUserDefault:@"Test"]];
    NSDictionary *dic = @{@"fen":self.correctCount, @"useTime":[NSString stringWithFormat:@"%d:%.2d",minutes, seconds], @"time":[self getCurrentTimes]};
    [array addObject:dic];
    [XYCommon SetUserDefault:@"Test" byValue:array];
    
}

- (NSString*)getCurrentTimes{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);
    return currentTimeString;
}



- (void)errorBtnAction {
    if (self.arrayDateError.count > 0) {
        ViewController *vcView = [[ViewController alloc] init];
        vcView.titleS = @"答错试题";
        vcView.arrayDate = self.arrayDateError;
        [self.navigationController pushViewController:vcView animated:YES];
    } else {
        [SVProgressHUD showWithStatus:@"您没有答错试题!"];
    }
}

- (void)againBtnAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AgainNotification" object:nil userInfo:nil];
    NSArray *vcArray = self.navigationController.viewControllers;
    [self.navigationController popToViewController:[vcArray objectAtIndex:1] animated:YES];
    
//    for(UIViewController *vc in vcArray) {
//        if ([vc isKindOfClass:[ViewController class]]) {
//            [self.navigationController popToViewController:vc animated:YES];
//        }
//    }
}

- (CAGradientLayer *)gradientLayer {
    if (_gradientLayer == nil) {
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = self.view.bounds;
        gl.startPoint = CGPointMake(0.59, 0.66);
        gl.endPoint = CGPointMake(0.57, 0.2);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:130/255.0 blue:72/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:242/255.0 green:24/255.0 blue:42/255.0 alpha:1.0].CGColor];
        gl.locations = @[@(0), @(1.0f)];
        _gradientLayer = gl;
    }
    return _gradientLayer;
}

- (CAGradientLayer *)gradientLayerS {
    if (_gradientLayerS == nil) {
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = self.view.bounds;
        gl.startPoint = CGPointMake(0.59, 0.66);
        gl.endPoint = CGPointMake(0.57, 0.2);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:62/255.0 green:144/255.0 blue:255/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:18/255.0 green:74/255.0 blue:245/255.0 alpha:1.0].CGColor];
        gl.locations = @[@(0), @(1.0f)];
        _gradientLayerS = gl;
    }
    return _gradientLayerS;
}

- (void)doBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
