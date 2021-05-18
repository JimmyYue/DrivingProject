//
//  ViewController.m
//  SZPageControllerDemo
//
//  Created by zxc on 2017/5/14.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import "ViewController.h"

#define ViewColor [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0]

#import "SZPageController.h"
#import "TempViewController.h"
#import "TempView.h"

@interface ViewController ()<SZPageControllerDataSource, SZPageControllerDelegate>

@property(nonatomic, weak) SZPageController *pageController;

@property(nonatomic, strong) TempViewController *vc;

@property(nonatomic) NSInteger index;

@end

@implementation ViewController

- (void)reloadNotification:(NSNotification *)notification {  // 设置右上角顶部答题正确错误个数
    NSDictionary *interuptionDict = notification.userInfo;
    if ([interuptionDict[@"count"] isEqualToString:@"1"]) {
        [self.secondBtn setTitle:[NSString stringWithFormat:@"%d", [self.secondBtn.titleLabel.text intValue] + 1] forState:UIControlStateNormal];
    } else {
        [self.firstBtn setTitle:[NSString stringWithFormat:@"%d", [self.firstBtn.titleLabel.text intValue] + 1] forState:UIControlStateNormal];
        if ([self.titleS isEqualToString:@"模拟考试"]) {
            [self.arrayDateError addObject:self.arrayDate[_index]];
        }
    }
}

- (void)againNotification {  // 重新考试
    self.arrayDate = [NSMutableArray array];
    self.arrayDateError = [NSMutableArray array];
    [self setDataCarType:self.car_type city:self.areacode course:self.course];
    [self.pageController reloadData];
    [self.firstBtn setTitle:@"0" forState:UIControlStateNormal];
    [self.secondBtn setTitle:@"0" forState:UIControlStateNormal];
    [self.pageController switchToIndex:0 animated:YES];
    [self.secondTypeBottomView setNewNSTimer];
}

- (void)setDataCarType:(NSString *)chapter_id {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"wyjk" ofType:@"db"];

    FMDatabase *dataBase = [FMDatabase databaseWithPath:path];
    [dataBase open];

    NSString *searchSql = nil;
    FMResultSet *set = nil;
    searchSql = @"select * from jk_question where chapter_id=?";
    set = [dataBase executeQuery:searchSql, chapter_id];
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
            if (stBit != 0){
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
        [self.arrayDate addObject:question];
    }
}

- (void)setDataCarType:(NSString *)car_type city:(NSString *)areacode course:(NSString *)course {
    
    self.arrayDate = [[NSMutableArray alloc] init];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"wyjk" ofType:@"db"];

    FMDatabase *dataBase = [FMDatabase databaseWithPath:path];
    [dataBase open];

    NSString *searchSql = nil;
    FMResultSet *set = nil;
//    if ([self.titleS isEqualToString:@"难题攻克"]) {
//        searchSql = @"select  *  from  jk_question as q  join  tb_record as r on q.question_id = r.question_id where q.chapter_id  in   (select chapter_id  from  jk_exam_regular   where car_type=? and course=? and (areacode like ? or areacode=0)  group by chapter_id) order by q.difficulty desc,q.wrong_rate desc limit 0,100";
//    } else {
        searchSql = @"select * from jk_question  where chapter_id in  (select chapter_id  from  jk_exam_regular   where car_type=? and course=? and (areacode like ? or areacode=0)  group by chapter_id)";
//    }
    
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
            if (stBit != 0){
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
        [self.arrayDate addObject:question];
    }
    if ([self.titleS isEqualToString:@"模拟考试"] || [self.titleS isEqualToString:@"难题攻克"]) {
        [self setArc];
    }
    if ([self.titleS isEqualToString:@"随机练习"]) {
        self.arrayDate = [self getRandomArrFrome:self.arrayDate];
    }
}

- (NSMutableArray*)getRandomArrFrome:(NSMutableArray*)arr
{
    NSMutableArray *newArr = [NSMutableArray new];
    while (newArr.count != arr.count) {
        //生成随机数
        int x =arc4random() % arr.count;
        id obj = arr[x];
        if (![newArr containsObject:obj]) {
            [newArr addObject:obj];
        }
    }
    return newArr;
}

- (void)setArc {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *arrayDataS = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10000; i++) {
        NSInteger a = arc4random()%self.arrayDate.count;
        NSString *str = [NSString stringWithFormat:@"%ld", (long)a];
        BOOL isbool = [array containsObject:str];
        if (isbool == NO) {
            [array addObject:str];
            Question*question = self.arrayDate[a];
            question.index = array.count;
            [arrayDataS addObject:question];
        }
        if (arrayDataS.count == 100) {
            break;
        }
    }
    self.arrayDate = [NSMutableArray arrayWithArray:arrayDataS];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ([self.titleS isEqualToString:@"顺序练习"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadHomeNotification" object:nil userInfo:@{@"count":[NSString stringWithFormat:@"%d", self.index + 1]}];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.titleS isEqualToString:@"模拟考试"]) {
        self.arrayDateError = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(againNotification) name:@"AgainNotification" object:nil];
    }
    
    if (![self.titleS isEqualToString:@"顺序练习"] && ![self.titleS isEqualToString:@"答错试题"] && ![self.titleS isEqualToString:@"未做练习"]) {
        self.arrayDate = [[NSMutableArray alloc] init];
        if ([self.titleS isEqualToString:@"章节练习"]) {
            [self setDataCarType:self.chapter_id];
        } else {
            [self setDataCarType:self.car_type city:self.areacode course:self.course];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNotification:) name:@"ReloadNotification" object:nil];
    
    self.firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.firstBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.firstBtn setTitle:@"0" forState:UIControlStateNormal];
    self.firstBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.firstBtn.frame = CGRectMake(0, 0, 66, 30);
    self.firstBtn.adjustsImageWhenHighlighted = NO;
    UIImage *buttonImage = [UIImage  imageNamed:@"wrong"];
    [self.firstBtn setImage:buttonImage forState:UIControlStateNormal];
    self.firstBtn.userInteractionEnabled = YES;
    [self.firstBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    UIBarButtonItem *backItemF = [[UIBarButtonItem alloc] initWithCustomView:self.firstBtn];
    
    self.secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.secondBtn setTitleColor:[UIColor colorWithHexString:@"285BF6"] forState:UIControlStateNormal];
    [self.secondBtn setTitle:@"0" forState:UIControlStateNormal];
    self.secondBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.secondBtn.frame = CGRectMake(0, 0, 66, 30);
    self.secondBtn.adjustsImageWhenHighlighted = NO;
    UIImage *buttonImageS = [UIImage  imageNamed:@"correct"];
    [self.secondBtn setImage:buttonImageS forState:UIControlStateNormal];
    self.secondBtn.userInteractionEnabled = YES;
    [self.secondBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    UIBarButtonItem *backItemS = [[UIBarButtonItem alloc] initWithCustomView:self.secondBtn];
    
    for (Question*question in self.arrayDate) {
        if (question.chooseArray.count > 0) {
            if (question.correct == YES) {
                [self.secondBtn setTitle:[NSString stringWithFormat:@"%d", [self.secondBtn.titleLabel.text intValue] + 1] forState:UIControlStateNormal];
            } else {
                [self.firstBtn setTitle:[NSString stringWithFormat:@"%d", [self.firstBtn.titleLabel.text intValue] + 1] forState:UIControlStateNormal];
            }
        }
    }
    
    self.navigationItem.rightBarButtonItems = @[backItemF, backItemS];
    
    self.title = self.titleS;
    self.view.backgroundColor = [UIColor whiteColor];
    
    SZPageController *pageVC = [[SZPageController alloc] init];
    pageVC.dataSource = self;
    pageVC.delegate = self;
    pageVC.switchTapEnabled = NO;
    pageVC.circleSwitchEnabled = NO;
    pageVC.contentModeController = YES;
    float topHeight = 55.5;
    if ([self.titleS isEqualToString:@"模拟考试"]) {
        topHeight = 0;
    }
    pageVC.viewFrame = CGRectMake(0, StatusRect + NavRect + topHeight, self.view.frame.size.width, self.view.frame.size.height - 61 - topHeight - StatusRect - NavRect);
    [self.view addSubview:pageVC.view];
    [self addChildViewController:pageVC];
    self.pageController = pageVC;

    [self.pageController reloadData];

    if ([self.titleS isEqualToString:@"模拟考试"]) {
         [self setViewBottomTime]; // 考试倒计时底部View
    } else {
        [self setTopView];  // 顶部类型切换
        [self setPracticeView]; //  上一页 下一页 页数弹窗 view
    }
    
    [self setPageView]; //  页数选择弹窗
    
    if ([self.titleS isEqualToString:@"模拟考试"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@，考试时间 45分钟，模拟考试下不能修改答案，每做错一题扣1分，合格标准为90分。", self.carTypeName]  preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.secondTypeBottomView setStarTime];
        }]];
        [self presentViewController:alert animated:YES completion:^{}];
    }
    
    if ([self.titleS isEqualToString:@"顺序练习"] && self.indexNow != 1) {
        [self.pageController switchToIndex:self.indexNow-1 animated:NO];
    }
}

#pragma mark - SZPageControllerDataSource
- (NSInteger)numberOfPagesInPageController:(SZPageController *)pageController {
    return self.arrayDate.count;
}

- (UIViewController *)pageController:(SZPageController *)pageController controllerForIndex:(NSInteger)index {
        self.vc = [[TempViewController alloc] init];
        self.vc.title = self.titleS;
        Question*questionS = self.arrayDate[index];
        questionS.topicType = self.topicType;
        self.vc.question = questionS;
        return self.vc;
}

- (UIView *)pageController:(SZPageController *)pageController viewForIndex:(NSInteger)index {
    TempView *view = [[TempView alloc] init];
    view.backgroundColor = ViewColor;
    view.model = self.arrayDate[index];
    return view;
}

#pragma mark - SZPageControllerDelegate
- (void)pageController:(SZPageController *)pageController currentController:(UIViewController *)currentController currentIndex:(NSInteger)currentIndex {
    self.index = currentIndex;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d / %lu", _index + 1, (unsigned long)self.arrayDate.count]];
    NSRange range1 = [[str string] rangeOfString:[NSString stringWithFormat:@"%lu", (unsigned long)self.arrayDate.count]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"909090"] range:range1];
    [self.firstTypeBottomView.pageBtn setAttributedTitle:str forState:UIControlStateNormal];
    [self.secondTypeBottomView.pageBtn setAttributedTitle:str forState:UIControlStateNormal];
}

- (void)pageController:(SZPageController *)pageController currentView:(UIView *)currentView currentIndex:(NSInteger)currentIndex {
    NSLog(@"%@ __ %ld", currentView, (long)currentIndex);
    self.index = currentIndex;
}

- (void)pageControllerDidSwitchToFirst:(SZPageController *)pageController {
    NSLog(@"第一个");
}

- (void)pageControllerDidSwitchToLast:(SZPageController *)pageController {
    NSLog(@"最后一个");
}

- (void)pageControllerSwitchToLastDisabled:(SZPageController *)pageController {
    NSLog(@"不能再向前了");
}

- (void)pageControllerSwitchToNextDisabled:(SZPageController *)pageController {
    NSLog(@"不能再向后了");
}

- (void)dealloc {
    NSLog(@"ViewController 释放了");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setTopView {  // 练习顶部 切换类型View
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, StatusRect + NavRect, CGRectGetWidth(self.view.bounds), 55)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    self.answerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.answerBtn.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) / 2, 55);
    [self.answerBtn setTitle:@"答题模式" forState:UIControlStateNormal];
    [self.answerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self.answerBtn setTitleColor:[UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1] forState:UIControlStateNormal];
    self.answerBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.answerBtn.selected = YES;
    [self.answerBtn addTarget:self action:@selector(answerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:self.answerBtn];
    
    self.endorsementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.endorsementBtn.frame = CGRectMake(CGRectGetWidth(self.view.bounds) / 2, 0, CGRectGetWidth(self.view.bounds) / 2, 55);
    [self.endorsementBtn setTitle:@"背题模式" forState:UIControlStateNormal];
    [self.endorsementBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self.endorsementBtn setTitleColor:[UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1] forState:UIControlStateNormal];
    self.endorsementBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.endorsementBtn addTarget:self action:@selector(endorsementBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:self.endorsementBtn];
    
    self.line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) / 4 - 50, 53.5, 100, 1.5)];
    self.line.backgroundColor = [UIColor colorWithHexString:@"285BF6"];
    [self.answerBtn addSubview:self.line];
    
    self.topicType = 1;  // 答题模式1 背题模式2
}

- (void)setPracticeView {  // 练习底部View 前后翻页 选择页
    self.firstTypeBottomView = [[NSBundle mainBundle] loadNibNamed:@"FirstTypeBottomView" owner:nil options:nil][0];
    self.firstTypeBottomView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - 60.5, self.view.frame.size.width, 60.5);
    self.firstTypeBottomView.delegate = self;
    [self.view addSubview:self.firstTypeBottomView];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"1 / %lu", (unsigned long)self.arrayDate.count]];
    NSRange range1 = [[str string] rangeOfString:[NSString stringWithFormat:@"%lu", (unsigned long)self.arrayDate.count]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"909090"] range:range1];
    [self.firstTypeBottomView.pageBtn setAttributedTitle:str forState:UIControlStateNormal];
}

- (void)setViewBottomTime {  // 考试倒计时底部view
    self.hiddenView = [[UIView alloc] initWithFrame:CGRectMake(0, StatusRect + NavRect, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 61 - StatusRect - NavRect)];
    self.hiddenView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.1];
    [self.view addSubview:self.hiddenView];
    
    self.hiddenView.hidden = YES;
    
    //  考试底部View
    self.secondTypeBottomView = [[NSBundle mainBundle] loadNibNamed:@"SecondTypeBottomView" owner:nil options:nil][0];
    self.secondTypeBottomView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - 60.5, self.view.frame.size.width, 60.5);
    self.secondTypeBottomView.delegate = self;
    [self.view addSubview:self.secondTypeBottomView];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"1 / %lu", (unsigned long)self.arrayDate.count]];
    NSRange range1 = [[str string] rangeOfString:[NSString stringWithFormat:@"%lu", (unsigned long)self.arrayDate.count]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"909090"] range:range1];
    [self.secondTypeBottomView.pageBtn setAttributedTitle:str forState:UIControlStateNormal];
}

- (void)setPageView {  // 试题菜单弹窗
    self.bottomPageView = [[NSBundle mainBundle] loadNibNamed:@"BottomPageView" owner:nil options:nil][0];
    self.bottomPageView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    self.bottomPageView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.3];
    self.bottomPageView.delegate = self;
    [self.view addSubview:self.bottomPageView];
}

- (void)answerBtnAction {  //  答题模式
    self.topicType = 1;
    [self.answerBtn addSubview:self.line];
    self.answerBtn.selected = YES;
    self.endorsementBtn.selected = NO;
    [self.vc setReloadTableView:self.topicType];
}

- (void)endorsementBtnAction {  // 背题模式
    self.topicType = 2;
    [self.endorsementBtn addSubview:self.line];
    self.endorsementBtn.selected = YES;
    self.answerBtn.selected = NO;
    [self.vc setReloadTableView:self.topicType];
}

- (void)setBefore:(FirstTypeBottomView *)view {  // 上一页
    [self.pageController switchToLastAnimated:YES];
}

- (void)setNext:(FirstTypeBottomView *)view {  // 下一页
    [self.pageController switchToNextAnimated:YES];
}

- (void)setPage:(FirstTypeBottomView *)view {  // 页数弹框
    [self setShowViewDate];
}

- (void)setShowViewDate {  //  显示底部弹出View
    self.bottomPageView.index = _index;
    self.bottomPageView.arrayDate = [_arrayDate copy];
    [self.bottomPageView setReloadCollectionView];
    [self setShowView];
}

- (void)setChoose:(BottomPageView *)view index:(NSInteger)index {  // 页数弹窗选择返回
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d / %lu", index + 1, (unsigned long)self.arrayDate.count]];
    NSRange range1 = [[str string] rangeOfString:[NSString stringWithFormat:@"%lu", (unsigned long)self.arrayDate.count]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"909090"] range:range1];
    [self.firstTypeBottomView.pageBtn setAttributedTitle:str forState:UIControlStateNormal];
    [self.secondTypeBottomView.pageBtn setAttributedTitle:str forState:UIControlStateNormal];
    [self.pageController switchToIndex:index animated:YES];
    [self setHiddenView];
}

- (void)setHidden:(BottomPageView *)view {  // 隐藏弹窗代理
    [self setHiddenView];
}

- (void)setShowView {  // 显示弹窗
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomPageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (void)setHiddenView { // 隐藏弹窗
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomPageView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (void)setToPage:(SecondTypeBottomView *)view {  // 底部页数
    [self setShowViewDate];
}

- (void)setTime:(SecondTypeBottomView *)view selected:(BOOL)selected {  // 时间倒计时
    if (selected == NO) {
        self.hiddenView.hidden = YES;
    } else {
        self.hiddenView.hidden = NO;
    }
}

- (void)setSubmite:(SecondTypeBottomView *)view {  // 立即交卷
    if (([self.firstBtn.titleLabel.text integerValue] + [self.secondBtn.titleLabel.text integerValue]) < 100) {
        NSInteger count = _arrayDate.count -([self.firstBtn.titleLabel.text integerValue] + [self.secondBtn.titleLabel.text integerValue]);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提交试卷" message:[NSString stringWithFormat:@"还有%ld道题没做，确定交卷?", (long)count] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.secondTypeBottomView.airTimer invalidate];
            ScoreViewController *scoreVC = [[ScoreViewController alloc] init];
            scoreVC.correctCount = self.secondBtn.titleLabel.text;
            scoreVC.errorCount = self.firstBtn.titleLabel.text;
            scoreVC.arrayDateError = self.arrayDateError;
            scoreVC.count = self.secondTypeBottomView.count;
            [self.navigationController pushViewController:scoreVC animated:YES];
        }]];
        [self presentViewController:alert animated:YES completion:^{ }];
    } else {
        [self.secondTypeBottomView.airTimer invalidate];
        ScoreViewController *scoreVC = [[ScoreViewController alloc] init];
        scoreVC.correctCount = self.secondBtn.titleLabel.text;
        scoreVC.correctCount = self.firstBtn.titleLabel.text;
        scoreVC.arrayDateError = self.arrayDateError;
        scoreVC.count = self.secondTypeBottomView.count;
        [self.navigationController pushViewController:scoreVC animated:YES];
    }
}

- (void)doBack {
    if ([self.titleS isEqualToString:@"答错试题"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end

