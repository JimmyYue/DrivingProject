//
//  PageViewController.h
//  eia
//
//  Created by JimmyYue on 2020/4/21.
//  Copyright © 2020 JimmyYue. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PageViewController : UIViewController

@property (nonatomic, strong) UIButton *backBtn;

- (void)setTitle:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
