//
//  PersonalViewController.m
//  DrivingProject
//
//  Created by JimmyYue on 2021/5/17.
//

#import "PersonalViewController.h"
#import "PersonalTableViewCell.h"
#import "LoginViewController.h"
#import "MyViewController.h"
#import "TestRecordsViewController.h"
#import "TheLatestView.h"
#import "SortingViewController.h"

@interface PersonalViewController ()

@end

@implementation PersonalViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
//    self.top.constant = StatusRect + NavRect;
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissSelectTimeViewBuy)];
    [self.loginView addGestureRecognizer:tap];
    
    self.titleArray = @[@[@"我的排名", @"考试记录", @"我的错题", @"题库类型", @"题库更新"], @[@"意见反馈", @"给个好评", @"设置"]];
    self.imgArray = @[@[@"my_paiming", @"my_jilu", @"my_cuoti", @"my_leixing", @"my_gengxin"], @[@"my_fankui", @"my_haoping", @"my_shezhi"]];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)dismissSelectTimeViewBuy {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

//设置表上有几个区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

//   每个分区cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.titleArray[section];
    return array.count;
}

//  分区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

//  去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 10;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

//设置view，将替代titleForHeaderInSection方法
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewHeader = [[UIView alloc] init];
    viewHeader.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    return viewHeader;
}

//  cell的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"PersonalTableViewCell";
    PersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PersonalTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", self.titleArray[indexPath.section][indexPath.row]];
    cell.img.image = [UIImage imageNamed:self.imgArray[indexPath.section][indexPath.row]];
    
    if (indexPath.section == 0 && indexPath.row == 3) {
        cell.typeLabel.text = @"小车";
    }
  
    //  取消cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//此代码可以进入下一级菜单时点击单元格高亮消失
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            SortingViewController *vcView = [[SortingViewController alloc] init];
            [self.navigationController pushViewController:vcView animated:YES];
        }
        if (indexPath.row == 1) {
            TestRecordsViewController *vcView = [[TestRecordsViewController alloc] init];
            vcView.titleS = @"考试记录";
            vcView.course = self.course;
            vcView.car_type = self.car_type;
            vcView.areacode = self.areacode;
            vcView.carTypeName = self.carTypeName;
            [self.navigationController pushViewController:vcView animated:YES];
        }
           
        if (indexPath.row == 4) {
            TheLatestView *theVC = [[NSBundle mainBundle] loadNibNamed:@"TheLatestView" owner:nil options:nil][0];
            theVC.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
            [self.view.window addSubview:theVC];
        }
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            WebViewController *webVC = [[WebViewController alloc] init];
            webVC.titleS = @"用户反馈";
            webVC.url = @"https://support.qq.com/products/300753";
            [self.navigationController pushViewController:webVC animated:YES];
        }
        if (indexPath.row == 2) {
            MyViewController *myVC = [[MyViewController alloc] init];
            [self.navigationController pushViewController:myVC animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
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
