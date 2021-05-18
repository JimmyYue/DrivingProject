//
//  ScoreTopView.h
//  SZPageControllerDemo
//
//  Created by JimmyYue on 2021/2/20.
//  Copyright © 2021 StenpZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNCirclePercentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScoreTopView : UIView

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UILabel *qualifiedLabel;

@property (strong, nonatomic) IBOutlet KNCirclePercentView *autoCalculateCircleView;

@property (strong, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) IBOutlet UIButton *errorBtn;
@property (strong, nonatomic) IBOutlet UIButton *againBtn;

@end

NS_ASSUME_NONNULL_END
