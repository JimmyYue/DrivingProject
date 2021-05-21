//
//  SortingTableViewCell.h
//  DrivingProject
//
//  Created by JimmyYue on 2021/5/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SortingTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *rankingImg;

@property (strong, nonatomic) IBOutlet UILabel *rankingLabel;

@property (strong, nonatomic) IBOutlet UIImageView *empImg;

@property (strong, nonatomic) IBOutlet UILabel *empLabel;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UILabel *fenLabel;

@end

NS_ASSUME_NONNULL_END
