//
//  AppDelegate.m
//  SZPageControllerDemo
//
//  Created by zxc on 2017/5/14.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import "AppDelegate.h"
#import "BAURLSessionProtocol.h"
#import <UserNotifications/UserNotifications.h>
#import <UMPush/UMessage.h>             // Push组件
#import <UMCommon/UMCommon.h>
#import <UserNotifications/UserNotifications.h>
#import <BUAdSDK/BUAdSDK.h>
#import "BUDAnimationTool.h"

//#import "BUDAdManager.h"
@interface AppDelegate ()<UNUserNotificationCenterDelegate, BUSplashAdDelegate, BUSplashZoomOutViewDelegate>
@property (nonatomic, assign) CFTimeInterval startTime;
@property (nonatomic, strong) BUSplashAdView *splashAdView;
@end

@implementation AppDelegate

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)) API_AVAILABLE(ios(10.0)){
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            //应用处于前台时的远程推送接受
            //关闭U-Push自带的弹出框
            [UMessage setAutoAlert:NO];
            //必须加这句代码
            [UMessage didReceiveRemoteNotification:userInfo];
            
      
        }else{
            [UMessage didReceiveRemoteNotification:userInfo];
            
            [self setNotification:[NSString stringWithFormat:@"%@", [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]]];
            
            //应用处于前台时的本地推送接受
            //        [self presentViewControllerWithPushInfoCode:[NSString stringWithFormat:@"%@", [userInfo objectForKey:@"code"]]];
        }
    } else {
        // Fallback on earlier versions
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    if (@available(iOS 10.0, *)) {
completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
    } else {
        // Fallback on earlier versions
    }
}

- (void)setNotification:(NSString *)meessag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:meessag delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"查看", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
    }
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        [self setNotification:[NSString stringWithFormat:@"%@", [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]]];
        
    }else{
        //应用处于后台时的本地推送接受
        [UMessage didReceiveRemoteNotification:userInfo];
        
        [self setNotification:[NSString stringWithFormat:@"%@", [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]]];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [NSURLProtocol registerClass:[BAURLSessionProtocol class]];
    
    [[UIApplication sharedApplication]setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    [NSThread sleepForTimeInterval:2.5];
    
    //  友盟
    [UMConfigure initWithAppkey:UMKey channel:@"App Store"];
    
    // Push组件基本功能配置
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //   type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter currentNotificationCenter].delegate=self;
    } else {
        // Fallback on earlier versions
    }
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        }else{
        }
    }];
    
    [UMConfigure setLogEnabled:YES];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self setupBUAdSDK];
    
    HomeViewController *VC = [[HomeViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:VC];
    self.window.rootViewController = nav;
    
    return YES;
}


- (void)setupBUAdSDK {
    
    NSInteger territory = [[NSUserDefaults standardUserDefaults]integerForKey:@"territory"];
    BOOL isNoCN = (territory>0&&territory!=BUAdSDKTerritory_CN);
    
    BUAdSDKConfiguration *configuration = [BUAdSDKConfiguration configuration];
    configuration.territory = isNoCN?BUAdSDKTerritory_NO_CN:BUAdSDKTerritory_CN;
    configuration.logLevel = BUAdSDKLogLevelVerbose;
    configuration.appID = @"5171230";
    [BUAdSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *error) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // splash AD demo
                [self addSplashAD];
                //
                // private config for demo
//                [self configDemo];
            });
        }
    }];
    
//    ///optional
//    ///CN china, NO_CN is not china
//    ///you must set Territory first,  if you need to set them
//    [BUAdSDKManager setTerritory:isNoCN?BUAdSDKTerritory_NO_CN:BUAdSDKTerritory_CN];
//    //optional
//    //GDPR 0 close privacy protection, 1 open privacy protection
//    [BUAdSDKManager setGDPR:0];
//    //optional
//    //Coppa 0 adult, 1 child
//    [BUAdSDKManager setCoppa:0];
//    // you can set idfa by yourself, it is optional and maybe will never be used.
//    [BUAdSDKManager setCustomIDFA:@"12345678-1234-1234-1234-123456789012"];
//#if DEBUG
//    // Whether to open log. default is none.
//    [BUAdSDKManager setLoglevel:BUAdSDKLogLevelDebug];
//#endif
//    //BUAdSDK requires iOS 9 and up
//    [BUAdSDKManager setAppID:[BUDAdManager appKey]];
//    [BUAdSDKManager setIsPaidApp:NO];
    
}

#pragma mark - Splash
- (void)addSplashAD {
    CGRect frame = [UIScreen mainScreen].bounds;
    self.splashAdView = [[BUSplashAdView alloc] initWithSlotID:@"887475868" frame:frame];
    // tolerateTimeout = CGFLOAT_MAX , The conversion time to milliseconds will be equal to 0
    self.splashAdView.tolerateTimeout = 5;
    // 不支持中途更改代理，中途更改代理会导致接收不到广告相关回调，如若存在中途更改代理场景，需自行处理相关逻辑，确保广告相关回调正常执行。
    self.splashAdView.delegate = self;

    UIWindow *keyWindow = self.window;
    self.startTime = CACurrentMediaTime();
    [self.splashAdView loadAdData];
    [keyWindow.rootViewController.view addSubview:self.splashAdView];
    self.splashAdView.rootViewController = keyWindow.rootViewController;
}

- (void)removeSplashAdView {
    if (self.splashAdView) {
        [self.splashAdView removeFromSuperview];
        self.splashAdView = nil;
    }
}

- (void)splashAdDidLoad:(BUSplashAdView *)splashAd {
    [self pbu_logWithSEL:_cmd msg:[NSString stringWithFormat:@"mediaExt %@",splashAd.mediaExt]];
    if (splashAd.zoomOutView) {
        UIViewController *parentVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        //Add this view to your container
        [parentVC.view insertSubview:splashAd.zoomOutView belowSubview:splashAd];
        splashAd.zoomOutView.rootViewController = parentVC;
        splashAd.zoomOutView.delegate = self;
    }
}

- (void)splashAdDidClose:(BUSplashAdView *)splashAd {
    if (splashAd.zoomOutView) {
        [[BUDAnimationTool sharedInstance] transitionFromView:splashAd toView:splashAd.zoomOutView splashCompletion:^{
            [splashAd removeFromSuperview];
        }];
    } else{
        // Be careful not to say 'self.splashadview = nil' here.
        // Subsequent agent callbacks will not be triggered after the 'splashAdView' is released early.
        [splashAd removeFromSuperview];
    }
    [self pbu_logWithSEL:_cmd msg:@""];
}

- (void)splashAdDidClick:(BUSplashAdView *)splashAd {
    if (splashAd.zoomOutView) {
        [splashAd.zoomOutView removeFromSuperview];
    }
    // Be careful not to say 'self.splashadview = nil' here.
    // Subsequent agent callbacks will not be triggered after the 'splashAdView' is released early.
    [splashAd removeFromSuperview];
    [self pbu_logWithSEL:_cmd msg:@""];
}

- (void)splashAdDidClickSkip:(BUSplashAdView *)splashAd {
    if (splashAd.zoomOutView) {
        [[BUDAnimationTool sharedInstance] transitionFromView:splashAd toView:splashAd.zoomOutView splashCompletion:^{
            [self removeSplashAdView];
        }];
    } else{
        // Click Skip, there is no subsequent operation, completely remove 'splashAdView', avoid memory leak
        [self removeSplashAdView];
    }
    [self pbu_logWithSEL:_cmd msg:@""];
}

- (void)splashAd:(BUSplashAdView *)splashAd didFailWithError:(NSError *)error {
    // Display fails, completely remove 'splashAdView', avoid memory leak
    [self removeSplashAdView];
    [self pbu_logWithSEL:_cmd msg:@""];
}

- (void)splashAdWillVisible:(BUSplashAdView *)splashAd {
    [self pbu_logWithSEL:_cmd msg:@""];
}





- (void)splashAdWillClose:(BUSplashAdView *)splashAd {
    [self pbu_logWithSEL:_cmd msg:@""];
}

- (void)splashAdDidCloseOtherController:(BUSplashAdView *)splashAd interactionType:(BUInteractionType)interactionType {
    // No further action after closing the other Controllers, completely remove the 'splashAdView' and avoid memory leaks
    [self removeSplashAdView];
    
    [self pbu_logWithSEL:_cmd msg:@""];
}



- (void)splashAdCountdownToZero:(BUSplashAdView *)splashAd {
    // When the countdown is over, it is equivalent to clicking Skip to completely remove 'splashAdView' and avoid memory leak
    if (!splashAd.zoomOutView) {
        [self removeSplashAdView];
    }
    [self pbu_logWithSEL:_cmd msg:@""];
}

#pragma mark - BUSplashZoomOutViewDelegate
- (void)splashZoomOutViewAdDidClick:(BUSplashZoomOutView *)splashAd {
    [self pbu_logWithSEL:_cmd msg:@""];
}

- (void)splashZoomOutViewAdDidClose:(BUSplashZoomOutView *)splashAd {
    // Click close, completely remove 'splashAdView', avoid memory leak
    [self removeSplashAdView];
    [self pbu_logWithSEL:_cmd msg:@""];
}

- (void)splashZoomOutViewAdDidAutoDimiss:(BUSplashZoomOutView *)splashAd {
    // Back down at the end of the countdown to completely remove the 'splashAdView' to avoid memory leaks
    [self removeSplashAdView];
    [self pbu_logWithSEL:_cmd msg:@""];
}

- (void)splashZoomOutViewAdDidCloseOtherController:(BUSplashZoomOutView *)splashAd interactionType:(BUInteractionType)interactionType {
    // No further action after closing the other Controllers, completely remove the 'splashAdView' and avoid memory leaks
    [self removeSplashAdView];
    [self pbu_logWithSEL:_cmd msg:@""];
}


- (void)pbu_logWithSEL:(SEL)sel msg:(NSString *)msg {
    CFTimeInterval endTime = CACurrentMediaTime();
    NSLog(@"SplashAdView In AppDelegate (%@) total run time: %gs, extraMsg:%@", NSStringFromSelector(sel), endTime - self.startTime, msg);
}















- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer  API_AVAILABLE(ios(10.0)){
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Driving"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}


@end
