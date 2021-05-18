//
//  WZAreaTableViewController.h
//  12123_Example
//
//  Created by che on 2018/9/17.
//  Copyright © 2018年 272789124@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface WZAreaTableViewController : PageViewController

@property (nonatomic, strong) NSString *titleS;
@property (nonatomic, strong) NSString *locationCity;
@property (nonatomic,copy)void (^blockCity)(NSString *city);
@end
