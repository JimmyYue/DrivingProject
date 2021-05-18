//
//  UIColor+YHLHexString.h
//  AFNetworking
//
//  Created by che on 2019/5/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (YHLHexString)

+ (UIColor *)colorWithHexString: (NSString *) hexString;
+ (UIColor *)colorWithHexString: (NSString *) hexString  alpha:(CGFloat) alpha;

@end

NS_ASSUME_NONNULL_END
