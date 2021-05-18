//
//  BottomPageView.h
//  SZPageControllerDemo
//
//  Created by JimmyYue on 2021/2/6.
//  Copyright © 2021 StenpZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BottomPageCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class BottomPageView;

@protocol BottomPageViewDelegate <NSObject>

@optional

- (void)setChoose:(BottomPageView *)view index:(NSInteger)index;

- (void)setHidden:(BottomPageView *)view;

- (void)setSubmit:(BottomPageView *)view;

@end

@interface BottomPageView : UIView<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property(nonatomic,assign)id<BottomPageViewDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *arrayDate;
@property (nonatomic, assign) NSInteger index;

@property (strong, nonatomic) IBOutlet UIView *hiddenView;

@property (strong, nonatomic) IBOutlet UIView *backView;

@property (strong, nonatomic) IBOutlet UILabel *correctLabel;

@property (strong, nonatomic) IBOutlet UILabel *wrongLabel;

@property (strong, nonatomic) IBOutlet UILabel *pageLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;

@property (strong, nonatomic) IBOutlet UICollectionView *pageCollectionView;

- (void)setReloadCollectionView;

@end

NS_ASSUME_NONNULL_END
