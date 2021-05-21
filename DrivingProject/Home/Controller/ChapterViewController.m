//
//  ChapterViewController.m
//  DrivingProject
//
//  Created by JimmyYue on 2021/2/25.
//

#import "ChapterViewController.h"


@interface ChapterViewController ()

@end

@implementation ChapterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setDataCarType:self.car_type city:self.areacode course:self.course];
    
    self.title = self.titleS;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
}

- (void)setDataCarType:(NSString *)car_type city:(NSString *)areacode course:(NSString *)course {
    
    self.arrayDate = [[NSMutableArray alloc] init];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"wyjk" ofType:@"db"];

    FMDatabase *dataBase = [FMDatabase databaseWithPath:path];
    [dataBase open];

    NSString *searchSql = nil;
    FMResultSet *set = nil;
    searchSql = @"select * from jk_chapter  where id in  (select chapter_id  from  jk_exam_regular   where car_type=? and course=? and (areacode like ? or areacode=0)  group by chapter_id)";
    set = [dataBase executeQuery:searchSql, car_type, course, areacode];
    //执行sql语句，在FMDB中，除了查询语句使用executQuery外，其余的增删改查都使用executeUpdate来实现。
    int i = 0;
    while (set.next) {
        i++;
        ChapterModel*chapterModel = [[ChapterModel alloc] init];
        chapterModel.title = [set stringForColumn:@"title"];
        chapterModel.chapter_id = [set stringForColumn:@"id"];
        chapterModel.count = [set stringForColumn:@"count"];
        [self.arrayDate addObject:chapterModel];
    }
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
    static NSString *str = @"ChapterTableViewCell";
    ChapterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ChapterTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    ChapterModel*chapterModel = self.arrayDate[indexPath.row];
    [cell.indexBtn setTitle:[NSString stringWithFormat:@"%ld", indexPath.row + 1] forState:UIControlStateNormal];
    cell.titleLabel.text = chapterModel.title;
    cell.countLabel.text = [NSString stringWithFormat:@"%@题", chapterModel.count];
    
    //  取消cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChapterModel*chapterModel = self.arrayDate[indexPath.row];
    ViewController *vcView = [[ViewController alloc] init];
    vcView.titleS = @"章节练习";
    vcView.chapter_id = chapterModel.chapter_id;
    [self.navigationController pushViewController:vcView animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 58;
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
