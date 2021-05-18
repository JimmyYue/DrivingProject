//
//  XYCommon.h
//  httptest
//
//  Created by 徐 颖 on 13-9-25.
//  Copyright (c) 2013年 joyce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYCommon : NSObject

+(void)SetUserDefault:(NSString *)key byValue:(id)value;
+(void)DeleteUserDefault:(NSString *)key;
+(id)GetUserDefault:(NSString *)key;
+(id)getSettingValue:(NSString *)key;
+(NSString *)GetDownloadFilePath:(NSString *)filename;
+(void)ShowMsgbyTitle:(NSString *)title ByMsg:(NSString *)msg byButtonTitle:(NSString *)buttontitle;
+ (BOOL)isNetwork;
+(void)DeleteLocalFile:(NSString*)fileName;
+(BOOL)FileExitsBypath:(NSString *)ff;
+(BOOL)checkIdCardNoFunc:(NSString *) IDCardNo;
+(void)CreateImagesFilePath:(NSString*)imageName withData:(NSData*)data;
+(NSString*)GetImagesFilePath:(NSString*)imageName;
// 正则判断手机号码地址格式
+(BOOL)isMobileNumber:(NSString *)mobileNum;
+(BOOL)isPostalNumber:(NSString *)postalNum;
+(BOOL)isValidateEmail:(NSString *)email;

//uilabel 字体宽度和高度
+(CGSize)sizeWithFrame:(UIFont *)font toString:(NSString *)string;

+(NSString *)getImageUrl:(NSString *)string;

+(NSString *)isCorrectNumber:(NSString *)correctNum;

@end
