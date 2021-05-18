//
//  ChapterViewController.h
//  DrivingProject
//
//  Created by JimmyYue on 2021/2/25.
//

#import <UIKit/UIKit.h>
#import "ChapterTableViewCell.h"
#import "ChapterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChapterViewController : PageViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *course;  // 科目
@property (nonatomic, strong) NSString *car_type;  // 类型
@property (nonatomic, strong) NSString *areacode;  // 区域

@property (nonatomic, strong) NSString *titleS;

@property (nonatomic, strong) NSMutableArray *arrayDate;
@property (strong, nonatomic) UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
