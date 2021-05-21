//
//  HomeViewController.m
//  SZPageControllerDemo
//
//  Created by JimmyYue on 2021/2/8.
//  Copyright © 2021 StenpZ. All rights reserved.
//

#import "HomeViewController.h"
#import "PersonalViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)reloadNotification:(NSNotification *)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    self.orderCountLabel.text = [NSString stringWithFormat:@"%@/%ld", interuptionDict[@"count"], self.arrayData.count];
    self.index = [interuptionDict[@"count"] integerValue];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNotification:) name:@"ReloadHomeNotification" object:nil];
    
    self.arrayData = [[NSMutableArray alloc] init];
    
    self.firstBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    self.firstBtn.selected = YES;
    
    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, 53, 70, 2)];
    self.line.backgroundColor = [UIColor blackColor];
    [self.firstBtn addSubview:self.line];
    
    _carTypeName = @"小车";
    _carTypeNameS = @"C1/C2/C3";
    _car_type = @"car";
    _course = @"kemu1";
    _areacode = @"310100000000";
    _locationCity = self.cityTitleLabel.text;
    
    [self setDataCarType:self.car_type city:self.areacode course:self.course];
    
    [self setLocationManager];
}

- (void)setDataCity:(NSString *)city {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"db"];
    
    FMDatabase *dataBase = [FMDatabase databaseWithPath:path];
    [dataBase open];
    
    NSString *searchSql = nil;
    FMResultSet *set = nil;
    searchSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? AND %@ = ?", @"tb_area", @"name", @"level"];
    set = [dataBase executeQuery:searchSql, city, @"2"];
    //执行sql语句，在FMDB中，除了查询语句使用executQuery外，其余的增删改查都使用executeUpdate来实现。
    int i = 0;
    while (set.next) {
        i++;
        self.areacode = [set stringForColumn:@"code"];
    }
    [self setDataCarType:self.car_type city:self.areacode course:self.course];
}

- (void)setDataCarType:(NSString *)car_type city:(NSString *)areacode course:(NSString *)course {
    
    self.arrayData = [NSMutableArray array];
    self.index = 1;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"wyjk" ofType:@"db"];

    FMDatabase *dataBase = [FMDatabase databaseWithPath:path];
    [dataBase open];

    NSString *searchSql = nil;
    FMResultSet *set = nil;
    searchSql = @"select * from jk_question  where chapter_id in  (select chapter_id  from  jk_exam_regular   where car_type=? and course=? and (areacode like ? or areacode=0)  group by chapter_id)";
    
    set = [dataBase executeQuery:searchSql, car_type, course, areacode];
    //执行sql语句，在FMDB中，除了查询语句使用executQuery外，其余的增删改查都使用executeUpdate来实现。
    int i = 0;
    while (set.next) {
        i++;
        Question*question = [[Question alloc] init];
        question.correct = YES;
        question.question = [set stringForColumn:@"question"];
        question.answer = [set stringForColumn:@"answer"];
        question.option_a = [set stringForColumn:@"option_a"];
        question.option_b = [set stringForColumn:@"option_b"];
        question.option_c = [set stringForColumn:@"option_c"];
        question.option_d = [set stringForColumn:@"option_d"];
        question.option_e = [set stringForColumn:@"option_e"];
        question.option_f = [set stringForColumn:@"option_f"];
        question.explain = [set stringForColumn:@"explain"];
        question.option_type = [set stringForColumn:@"option_type"];
        question.media_url = [set stringForColumn:@"media_url"];
        question.index = i;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if ([IsBlankString isBlankString:question.option_a] == NO) {
            [dic setObject:question.option_a forKey:@"A"];
        }
        if ([IsBlankString isBlankString:question.option_b] == NO) {
            [dic setObject:question.option_b forKey:@"B"];
        }
        if ([IsBlankString isBlankString:question.option_c] == NO) {
            [dic setObject:question.option_c forKey:@"C"];
        }
        if ([IsBlankString isBlankString:question.option_d] == NO) {
            [dic setObject:question.option_d forKey:@"D"];
        }
        question.choose = dic;
        
        NSMutableArray *arrayA = [[NSMutableArray alloc] init];
        int option;
        for (int i = 0; i < 4; i++) {
            NSInteger stBit = (1 << (i+4) & [question.answer integerValue]);
            if (stBit != 0) {
                option = i;
                if (option == 0) {
                    [arrayA addObject:@"A"];
                } else if (option == 1) {
                    [arrayA addObject:@"B"];
                } else if (option == 2) {
                    [arrayA addObject:@"C"];
                } else if (option == 3) {
                    [arrayA addObject:@"D"];
                }
                if (![question.option_type isEqualToString:@"2"]) {
                    break;
                }
            }
        }
        question.answerS = arrayA;
        [self.arrayData addObject:question];
    }
    //  顺序练习题目个数
    self.orderCountLabel.text = [NSString stringWithFormat:@"1/%lu", (unsigned long)self.arrayData.count];
}

- (IBAction)firstBtnAction:(id)sender {
    if ( self.firstBtn.selected == NO) {
        if ([self.car_type isEqualToString:@"car"] || [self.car_type isEqualToString:@"truck"] || [self.car_type isEqualToString:@"bus"] || [self.car_type isEqualToString:@"moto"]) {
            self.course = @"kemu1";
        }
        [self setDataCarType:self.car_type city:self.areacode course:self.course];
        self.firstBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        self.fourthBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        [self.firstBtn addSubview:self.line];
        self.firstBtn.selected = YES;
        self.fourthBtn.selected = NO;
    }
}

- (IBAction)fourthBtnAction:(id)sender {
    if ( self.fourthBtn.selected == NO) {
        self.firstBtn.selected = NO;
        self.fourthBtn.selected = YES;
        self.fourthBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        self.firstBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        [self.fourthBtn addSubview:self.line];
        self.course = @"kemu4";
        [self setDataCarType:self.car_type city:self.areacode course:self.course];
    }
}

- (IBAction)randomBtnAction:(id)sender {  // 随机
    ViewController *vcView = [[ViewController alloc] init];
    vcView.titleS = @"随机练习";
    vcView.course = self.course;
    vcView.car_type = self.car_type;
    vcView.areacode = self.areacode;
    [self.navigationController pushViewController:vcView animated:YES];
}

- (IBAction)userBtnAction:(id)sender {  // 我的
    PersonalViewController *myVC = [[PersonalViewController alloc] init];
    myVC.course = self.course;
    myVC.car_type = self.car_type;
    myVC.areacode = self.areacode;
    NSString *type;
    if ([_course isEqualToString:@"kemu1"]) {
        type = @"科目一";
    } else if ([_course isEqualToString:@"kemu4"]) {
        type = @"科目四";
    } else {
        type = @"资格证";
    }
    myVC.carTypeName = [NSString stringWithFormat:@"%@-%@%@", self.carTypeName, self.carTypeNameS, type];
    [self.navigationController pushViewController:myVC animated:YES];
}

- (IBAction)problemBtnAction:(id)sender {  // 难题
    ViewController *vcView = [[ViewController alloc] init];
    vcView.titleS = @"难题攻克";
    vcView.course = self.course;
    vcView.car_type = self.car_type;
    vcView.areacode = self.areacode;
    [self.navigationController pushViewController:vcView animated:YES];
}

- (IBAction)orderBtnAction:(id)sender {
    ViewController *vcView = [[ViewController alloc] init];
    vcView.titleS = @"顺序练习";
    vcView.indexNow = self.index;
    vcView.arrayDate = self.arrayData;
    [self.navigationController pushViewController:vcView animated:YES];
}

- (IBAction)chapterBtnAction:(id)sender {  // 章节练习
    ChapterViewController *vcView = [[ChapterViewController alloc] init];
    vcView.titleS = @"章节练习";
    vcView.course = self.course;
    vcView.car_type = self.car_type;
    vcView.areacode = self.areacode;
    [self.navigationController pushViewController:vcView animated:YES];
}

- (IBAction)notMakeBtnAction:(id)sender {  // 未做练习
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.arrayData];
    for (int i = 0; i < self.arrayData.count; i++) {
        Question *question = self.arrayData[i];
        if (question.state == YES) {
            [array removeObject:question];
        }
    }
    ViewController *vcView = [[ViewController alloc] init];
    vcView.titleS = @"未做练习";
    vcView.arrayDate = array;
    [self.navigationController pushViewController:vcView animated:YES];
}

- (IBAction)testBtnAction:(id)sender {
    TestRecordsViewController *vcView = [[TestRecordsViewController alloc] init];
    vcView.titleS = @"考试记录";
    vcView.course = self.course;
    vcView.car_type = self.car_type;
    vcView.areacode = self.areacode;
    NSString *type;
    if ([_course isEqualToString:@"kemu1"]) {
        type = @"科目一";
    } else if ([_course isEqualToString:@"kemu4"]) {
        type = @"科目四";
    } else {
        type = @"资格证";
    }
    vcView.carTypeName = [NSString stringWithFormat:@"%@-%@%@", self.carTypeName, self.carTypeNameS, type];
    [self.navigationController pushViewController:vcView animated:YES];
}

- (IBAction)resultsBtnAction:(id)sender {
    SortingViewController *sortVC = [[SortingViewController alloc] init];
    [self.navigationController pushViewController:sortVC animated:YES];
}

- (IBAction)simulationBtnAction:(id)sender {  // 模拟考试
    ViewController *vcView = [[ViewController alloc] init];
    vcView.titleS = @"模拟考试";
    NSString *type;
    if ([_course isEqualToString:@"kemu1"]) {
        type = @"科目一";
    } else if ([_course isEqualToString:@"kemu4"]) {
        type = @"科目四";
    } else {
        type = @"资格证";
    }
    vcView.carTypeName = [NSString stringWithFormat:@"%@-%@%@", self.carTypeName, self.carTypeNameS, type];
    vcView.course = self.course;
    vcView.car_type = self.car_type;
    vcView.areacode = self.areacode;
    [self.navigationController pushViewController:vcView animated:YES];
}

- (IBAction)typeBtnAction:(id)sender {
    ChooseQuestionBankViewController *chooseVC = [[ChooseQuestionBankViewController alloc] init];
    chooseVC.locationCity = self.cityTitleLabel.text;
    chooseVC.carTypeName = self.carTypeName;
    chooseVC.carTypeNameS = self.carTypeNameS;
    chooseVC.car_type = self.car_type;
    [chooseVC setBlockCity:^(NSString * _Nonnull city, NSString* _Nonnull type, NSString* _Nonnull name, NSString* _Nonnull nameS) {
        if (![self->_car_type isEqualToString:type] || ![self->_locationCity isEqualToString:city] ) {
            self.typeTitleLabel.text = [NSString stringWithFormat:@"前往题库(%@)", name];
            self.cityTitleLabel.text = city;
            self.carTypeName = name;
            self.carTypeNameS = nameS;
            self.car_type = type;
            self.firstBtn.selected = YES;
            self.fourthBtn.selected = NO;
            [self.firstBtn addSubview:self.line];
            if ([type isEqualToString:@"car"] || [type isEqualToString:@"truck"] || [type isEqualToString:@"bus"] || [type isEqualToString:@"moto"]) {
                self.fourthBtn.hidden = NO;
                self.course = @"kemu1";
                [self.firstBtn setTitle:@"科目一" forState:UIControlStateNormal];
            } else {
                self.fourthBtn.hidden = YES;
                self.course = @"zigezheng";
                [self.firstBtn setTitle:@"资格证" forState:UIControlStateNormal];
            }
            if ([city containsString:@"市"]) {
                [self setDataCity:[city substringToIndex:city.length - 1]];
            } else {
                [self setDataCity:city];
            }
        }
    }];
    [self.navigationController pushViewController:chooseVC animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status)
    {
        case kCLAuthorizationStatusNotDetermined:
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [_locationManager requestAlwaysAuthorization];
            }
            break;
        default:
            break;
    }
}

- (void)setLocationManager {
    
    self.locationManager=[[CLLocationManager alloc]init];
    self.locationManager.delegate=self;
    //定位精度
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    //多长距离更新一次位置
    self.locationManager.distanceFilter = 10;
    
    if (UIDevice.currentDevice.systemVersion.integerValue>8.0) {
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"开启定位快速选择当前位置所在城市!" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:YES completion:^{ }];
    }
    
    self.location = NO;
}

//  定位
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currLocation = [locations lastObject];

    // 位置反编码
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:self.currLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error||placemarks.count==0) {
            NSLog(@"error:%@", error);
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"定位失败, 请检查网络与定位权限是否开启!" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alert animated:YES completion:^{ }];
        }else {
            self.placemark=[placemarks firstObject];
            if (self.location == NO) {
                self.locationCity = self.placemark.locality;  // 定位城市
                self.location = YES;  // 因定位方法重复调用多次 用此字段限制重复请求数据
                self.cityTitleLabel.text = self.placemark.locality;
                if ([self.locationCity containsString:@"市"]) {
                    [self setDataCity:[self.locationCity substringToIndex:self.locationCity.length - 1]];
                } else {
                    [self setDataCity:self.locationCity];
                }
            }
        }
    }];

    if (self.currLocation != nil) {
        [self.locationManager stopUpdatingLocation];
    }
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
