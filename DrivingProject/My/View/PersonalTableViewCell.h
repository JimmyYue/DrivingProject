//
//  PersonalTableViewCell.h
//  DrivingProject
//
//  Created by JimmyYue on 2021/5/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonalTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *img;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *typeLabel;


@end

NS_ASSUME_NONNULL_END
