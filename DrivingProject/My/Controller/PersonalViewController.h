//
//  PersonalViewController.h
//  DrivingProject
//
//  Created by JimmyYue on 2021/5/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonalViewController : WhiteViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *loginView;
@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSArray *imgArray;

@property (nonatomic, strong) NSString *course;  // 科目
@property (nonatomic, strong) NSString *car_type;  // 类型
@property (nonatomic, strong) NSString *areacode;  // 区域
@property (nonatomic, strong) NSString *carTypeName;
@end

NS_ASSUME_NONNULL_END
