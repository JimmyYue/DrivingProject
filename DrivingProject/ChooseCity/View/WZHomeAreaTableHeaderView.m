//
//  WZHomeAreaTableHeaderView.m
//  12123_Example
//
//  Created by che on 2018/9/17.
//  Copyright © 2018年 272789124@qq.com. All rights reserved.
//

#import "WZHomeAreaTableHeaderView.h"
#import <MapKit/MapKit.h>

@interface WZHomeAreaTableHeaderView()

@property (weak, nonatomic) IBOutlet UIView *areaView;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

- (IBAction)locationBtn:(id)sender;
- (IBAction)btnClick:(id)sender;

@end

@implementation WZHomeAreaTableHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
    
    if ([IsBlankString isBlankString:self.locationCity] == NO) {
        [self.locationBtn setTitle:_locationCity forState:UIControlStateNormal];
    } else {
        [self setLocationManager];
    }
  
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupUI {
    for (UIButton *btn in self.areaView.subviews) {
        if ([btn isKindOfClass:UIButton.class]) {
            btn.layer.borderColor = [UIColor colorWithHexString:@"D2D4D9"].CGColor;
            btn.layer.borderWidth = 0.5;
            btn.layer.cornerRadius = 2;
            [btn setBackgroundImage:[UIImage ms_imageWithColor:[UIColor colorWithHexString:@"F7F7F8"]] forState:UIControlStateHighlighted];
        }
    }
}

- (void)updateCity:(NSNotification *)not {
    NSString *city = not.object[@"city"];
    if (city != nil) {
        [self.locationBtn setTitle:city forState:UIControlStateNormal];
    }
}

- (IBAction)locationBtn:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (![btn.currentTitle isEqualToString:@"定位中"]) {
        self.blockCity(btn.currentTitle);
    } else {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"开启定位快速选择当前位置所在城市" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"手动选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"前往开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }]];
            [self.selfView presentViewController:alert animated:YES completion:^{ }];
        }
        else {
            [self setLocationManager];
        }
    }
}

- (IBAction)btnClick:(id)sender {
    for (UIButton *btn in self.areaView.subviews) {
        if ([btn isKindOfClass:UIButton.class]) {
            if (btn.currentImage == nil) {
                btn.layer.borderColor = [UIColor colorWithHexString:@"D2D4D9"].CGColor;
                btn.layer.borderWidth = 0.5;
                btn.layer.cornerRadius = 2;
                [btn setTitleColor:[UIColor colorWithHexString:@"39424D"] forState:UIControlStateNormal];
                btn.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
            }
        }
    }
    
    UIButton *btn = (UIButton *)sender;
    btn.backgroundColor = [UIColor colorWithHexString:@"F7F7F8"];
    [btn setTitleColor:[UIColor colorWithHexString:@"285BF6"] forState:UIControlStateNormal];
    
    self.blockCity(btn.currentTitle);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status)
    {
        case kCLAuthorizationStatusNotDetermined:
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [_locationManager requestAlwaysAuthorization];
            }
            break;
        default:
            break;
    }
}

- (void)setLocationManager {
    
    self.locationManager=[[CLLocationManager alloc]init];
    self.locationManager.delegate=self;
    //定位精度
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    //多长距离更新一次位置
    self.locationManager.distanceFilter = 10;
    
    if (UIDevice.currentDevice.systemVersion.integerValue>8.0)
    {
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
    } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"开启定位快速选择当前位置所在城市!" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [self.selfView presentViewController:alert animated:YES completion:^{ }];
    }
    
    self.location = NO;
}

//  定位
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currLocation = [locations lastObject];

    // 位置反编码
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:self.currLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error||placemarks.count==0) {
            NSLog(@"error:%@", error);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"定位失败, 请检查网络与定位权限是否开启!" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self.selfView presentViewController:alert animated:YES completion:^{ }];
        }else {

            self.placemark=[placemarks firstObject];
            if (self.location == NO) {
                self.locationCity = self.placemark.locality;  // 定位城市
                self.location = YES;  // 因定位方法重复调用多次 用此字段限制重复请求数据
                [self.locationBtn setTitle:self.placemark.locality forState:UIControlStateNormal];
            }
        }
    }];

    if (self.currLocation != nil) {
        [self.locationManager stopUpdatingLocation];
    }
}


@end
