//
//  ChapterTableViewCell.h
//  DrivingProject
//
//  Created by JimmyYue on 2021/2/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChapterTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *indexBtn;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *countLabel;

@end

NS_ASSUME_NONNULL_END
