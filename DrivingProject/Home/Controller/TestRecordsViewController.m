//
//  TestRecordsViewController.m
//  DrivingProject
//
//  Created by JimmyYue on 2021/2/26.
//

#import "TestRecordsViewController.h"

@interface TestRecordsViewController ()

@end

@implementation TestRecordsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.arrayDate = [XYCommon GetUserDefault:@"Test"];
    _arrayDate=(NSMutableArray *)[[_arrayDate reverseObjectEnumerator] allObjects];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.titleS;
    self.view.backgroundColor = [UIColor whiteColor];

    self.arrayDate = [[NSMutableArray alloc] init];
    
    _lastStr = 0;
    _lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, StatusRect + NavRect, kDeviceWidth - 110, 55)];
    _lastLabel.font = [UIFont systemFontOfSize:15];
    _lastLabel.backgroundColor = [UIColor whiteColor];
    _lastLabel.text = @"您的历史最高成绩0分";
    [self.view addSubview:_lastLabel];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(kDeviceWidth - 95, StatusRect + NavRect + 12.5, 80, 30);
    [cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"去考试" forState:UIControlStateNormal];
    cancelBtn.layer.cornerRadius = 15.0f;
    cancelBtn.backgroundColor = [UIColor colorWithHexString:@"285BF6"];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:cancelBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _lastLabel.frame.origin.y + _lastLabel.frame.size.height, kDeviceWidth, 1)];
    line.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    [self.view addSubview:line];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _lastLabel.frame.origin.y + _lastLabel.frame.size.height + 1, self.view.frame.size.width, self.view.frame.size.height - _lastLabel.frame.size.height - StatusRect - NavRect - 1)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (void)cancelBtnAction {
    ViewController *vcView = [[ViewController alloc] init];
    vcView.titleS = @"模拟考试";
    vcView.carTypeName = self.carTypeName;
    vcView.course = self.course;
    vcView.car_type = self.car_type;
    vcView.areacode = self.areacode;
    [self.navigationController pushViewController:vcView animated:YES];
}

//  设置表上有几个区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//  每个分区cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayDate.count;
}

//  cell的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *str = @"TestRecordsTableViewCell";
    TestRecordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"TestRecordsTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    
    if ([self.arrayDate[indexPath.row][@"fen"] intValue] < 90) {
        cell.pointsLabel.textColor = [UIColor redColor];
    } else {
        cell.pointsLabel.textColor = [UIColor colorWithHexString:@"285BF6"];
    }
    if (_lastStr < [self.arrayDate[indexPath.row][@"fen"] integerValue]) {
        _lastStr = [self.arrayDate[indexPath.row][@"fen"] integerValue];
    }
    cell.pointsLabel.text = self.arrayDate[indexPath.row][@"fen"];
    cell.userTimeLabel.text = self.arrayDate[indexPath.row][@"useTime"];
    cell.timeLabel.text = self.arrayDate[indexPath.row][@"time"];
    
    if (indexPath.row  == self.arrayDate.count - 1) {
        _lastLabel.text = [NSString stringWithFormat:@"您的历史最高成绩%ld分", _lastStr];
    }
   
    //  取消cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 55;
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
