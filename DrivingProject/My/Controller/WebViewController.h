//
//  WebViewController.h
//  Driving
//
//  Created by JimmyYue on 2021/2/23.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : PageViewController

@property (weak, nonatomic) CALayer *progresslayer;
@property (nonatomic, strong) NSString *titleS;
@property (nonatomic, strong) NSString *url;

@end

NS_ASSUME_NONNULL_END
