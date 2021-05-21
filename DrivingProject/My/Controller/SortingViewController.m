//
//  SortingViewController.m
//  DrivingProject
//
//  Created by JimmyYue on 2021/5/19.
//

#import "SortingViewController.h"

@interface SortingViewController ()

@end

@implementation SortingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"排行榜";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}


//   每个分区cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

//  cell的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"SortingTableViewCell";
    SortingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SortingTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    
    cell.rankingLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    if (indexPath.row > 2) {
        cell.rankingImg.hidden = YES;
        cell.timeLabel.textColor = [UIColor colorWithHexString:@"808080"];
        cell.fenLabel.textColor = [UIColor colorWithHexString:@"033EFF"];
    } else {
        cell.rankingImg.hidden = NO;
        if (indexPath.row == 1) {
            cell.rankingImg.image = [UIImage imageNamed:@"my_second"];
        }
        if (indexPath.row == 2) {
            cell.rankingImg.image = [UIImage imageNamed:@"my_third"];
        }
    }
  
    //  取消cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//此代码可以进入下一级菜单时点击单元格高亮消失
    
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
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
