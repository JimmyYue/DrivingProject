//
//  ViewController.h
//  SZPageControllerDemo
//
//  Created by zxc on 2017/5/14.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageViewController.h"
#import "BottomPageView.h"
#import "FirstTypeBottomView.h"
#import "SecondTypeBottomView.h"
#import "ScoreViewController.h"

@interface ViewController : PageViewController<FirstTypeBottomViewDelegate, SecondTypeBottomViewDelegate, BottomPageViewDelegate>

@property (nonatomic, assign) NSInteger indexNow;

@property (nonatomic, strong) NSString *chapter_id;  // 科目
@property (nonatomic, strong) NSString *course;  // 科目
@property (nonatomic, strong) NSString *car_type;  // 类型
@property (nonatomic, strong) NSString *areacode;  // 区域
@property (nonatomic, strong) NSString *carTypeName; // 考题类型
@property (nonatomic, strong) NSString *titleS;
@property (nonatomic, strong) NSMutableArray *arrayDate;
@property (nonatomic, strong) NSMutableArray *arrayDateError;
@property (nonatomic, strong) UIButton *answerBtn;
@property (nonatomic, strong) UIButton *endorsementBtn;
@property (nonatomic, assign) NSInteger topicType;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) FirstTypeBottomView *firstTypeBottomView;
@property (nonatomic, strong) SecondTypeBottomView *secondTypeBottomView;
@property (nonatomic, strong) UIView *hiddenView;
@property (nonatomic, strong) BottomPageView*bottomPageView;
@property (nonatomic, strong) UIButton *firstBtn;
@property (nonatomic, strong) UIButton *secondBtn;

@end

