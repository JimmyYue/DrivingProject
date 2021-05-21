//
//  HomeViewController.h
//  SZPageControllerDemo
//
//  Created by JimmyYue on 2021/2/8.
//  Copyright © 2021 StenpZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "ChooseQuestionBankViewController.h"
#import "MyViewController.h"
#import "Question.h"
#import "ChapterViewController.h"
#import "TestRecordsViewController.h"
#import "SortingViewController.h"
#import <fmdb/FMDatabase.h>
#import <fmdb/FMResultSet.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currLocation;
@property (nonatomic, strong) CLPlacemark *placemark;
@property (nonatomic, strong) NSString *locationCity;
@property (nonatomic, assign) BOOL location;

@property (nonatomic, strong) NSString *carTypeName;
@property (nonatomic, strong) NSString *carTypeNameS;

@property (nonatomic, strong) NSMutableArray *arrayData;

@property (strong, nonatomic) IBOutlet UIButton *firstBtn;
- (IBAction)firstBtnAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *fourthBtn;
- (IBAction)fourthBtnAction:(id)sender;

@property (nonatomic, strong) UIView *line;

@property (strong, nonatomic) IBOutlet UIButton *userBtn;
- (IBAction)userBtnAction:(id)sender;

- (IBAction)randomBtnAction:(id)sender;  // 随机练习

- (IBAction)problemBtnAction:(id)sender;  // 难题攻克

- (IBAction)orderBtnAction:(id)sender;  // 顺序练习
@property (strong, nonatomic) IBOutlet UILabel *orderCountLabel;

- (IBAction)chapterBtnAction:(id)sender;  // 章节练习

- (IBAction)notMakeBtnAction:(id)sender;  // 未做练习

- (IBAction)testBtnAction:(id)sender;  // 考试记录

- (IBAction)simulationBtnAction:(id)sender;  // 模拟考试

- (IBAction)resultsBtnAction:(id)sender; // 成绩排行

@property (strong, nonatomic) IBOutlet UILabel *typeTitleLabel;
- (IBAction)typeBtnAction:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *cityTitleLabel;

@property (nonatomic, strong) NSString *course;  // 科目
@property (nonatomic, strong) NSString *car_type;  // 类型
@property (nonatomic, strong) NSString *areacode;  // 区域

@property (nonatomic, assign) NSInteger index;
@end

NS_ASSUME_NONNULL_END
