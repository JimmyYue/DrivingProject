//
//  FirstTypeBottomView.h
//  SZPageControllerDemo
//
//  Created by JimmyYue on 2021/2/7.
//  Copyright © 2021 StenpZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FirstTypeBottomView;

@protocol FirstTypeBottomViewDelegate <NSObject>

@optional

- (void)setBefore:(FirstTypeBottomView *)view;

- (void)setNext:(FirstTypeBottomView *)view;

- (void)setPage:(FirstTypeBottomView *)view;

@end

@interface FirstTypeBottomView : UIView

@property(nonatomic,assign)id<FirstTypeBottomViewDelegate>delegate;

- (IBAction)beforeBtnAction:(id)sender;
- (IBAction)nextBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *pageBtn;
- (IBAction)pageBtnAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
