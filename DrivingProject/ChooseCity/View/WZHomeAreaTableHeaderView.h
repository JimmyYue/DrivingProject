//
//  WZHomeAreaTableHeaderView.h
//  12123_Example
//
//  Created by che on 2018/9/17.
//  Copyright © 2018年 272789124@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZHomeAreaTableHeaderView : UIView<CLLocationManagerDelegate>

@property (nonatomic, strong) UIViewController *selfView;

@property (nonatomic,copy)void (^blockCity)(NSString *city);

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currLocation;
@property (nonatomic, strong) CLPlacemark *placemark;
@property (nonatomic, strong) NSString *locationCity;
@property (nonatomic, assign) BOOL location;

@end
