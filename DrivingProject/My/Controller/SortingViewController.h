//
//  SortingViewController.h
//  DrivingProject
//
//  Created by JimmyYue on 2021/5/19.
//

#import <UIKit/UIKit.h>
#import "SortingTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SortingViewController : PageViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

NS_ASSUME_NONNULL_END
