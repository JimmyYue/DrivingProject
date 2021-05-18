//
//  ScoreViewController.h
//  SZPageControllerDemo
//
//  Created by JimmyYue on 2021/2/20.
//  Copyright © 2021 StenpZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreTopView.h"
#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScoreViewController : PageViewController

@property (nonatomic, strong) NSString *correctCount;
@property (nonatomic, strong) NSString *errorCount;
@property (nonatomic, strong) NSMutableArray *arrayDateError;
@property (nonatomic,assign) int count;
@property (nonatomic,strong) CAGradientLayer *gradientLayer;
@property (nonatomic,strong) CAGradientLayer *gradientLayerS;
@property (nonatomic, strong) ScoreTopView *scoreTopView;

@end

NS_ASSUME_NONNULL_END
