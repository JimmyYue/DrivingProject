//
//  UIhelpTools.m
//  eia
//
//  Created by JimmyYue on 2020/5/29.
//  Copyright © 2020 JimmyYue. All rights reserved.
//

#import "UIhelpTools.h"

@implementation UIhelpTools

+ (CGFloat)getStatusBarHight {
    float statusBarHeight = 0;
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
        statusBarHeight = statusBarManager.statusBarFrame.size.height;
    } else {
        statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    return statusBarHeight;
}

@end
