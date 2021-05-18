//
//  TestRecordsViewController.h
//  DrivingProject
//
//  Created by JimmyYue on 2021/2/26.
//

#import <UIKit/UIKit.h>
#import "TestRecordsTableViewCell.h"
#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestRecordsViewController : PageViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *titleS;
@property (nonatomic, assign) NSInteger lastStr;
@property (nonatomic, strong) UILabel *lastLabel;
@property (nonatomic, strong) NSMutableArray *arrayDate;
@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) NSString *course;  // 科目
@property (nonatomic, strong) NSString *car_type;  // 类型
@property (nonatomic, strong) NSString *areacode;  // 区域
@property (nonatomic, strong) NSString *carTypeName;

@end

NS_ASSUME_NONNULL_END
