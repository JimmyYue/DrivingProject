//
//  SecondTypeBottomView.h
//  SZPageControllerDemo
//
//  Created by JimmyYue on 2021/2/7.
//  Copyright © 2021 StenpZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SecondTypeBottomView;

@protocol SecondTypeBottomViewDelegate <NSObject>

@optional

- (void)setToPage:(SecondTypeBottomView *)view;

- (void)setTime:(SecondTypeBottomView *)view selected:(BOOL)selected;

- (void)setSubmite:(SecondTypeBottomView *)view;

@end

@interface SecondTypeBottomView : UIView

@property(nonatomic,assign)id<SecondTypeBottomViewDelegate>delegate;

@property (strong, nonatomic) IBOutlet UIButton *pageBtn;
- (IBAction)pageBtnAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *backView;

@property (strong, nonatomic) IBOutlet UIButton *timeBtn;
- (IBAction)timeBtnAction:(id)sender;

- (IBAction)submitBtnAction:(id)sender;

@property (nonatomic, strong) NSTimer *airTimer;
@property (nonatomic, assign) int count;

- (void)setNewNSTimer;
- (void)setStarTime;

@end

NS_ASSUME_NONNULL_END
