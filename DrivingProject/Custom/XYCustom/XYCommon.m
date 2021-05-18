//
//  XYCommon.m
//  httptest
//
//  Created by 徐 颖 on 13-9-25.
//  Copyright (c) 2013年 joyce. All rights reserved.
//

#import "XYCommon.h"
//#import "Reachability.h"
@implementation XYCommon

+(void)SetUserDefault:(NSString *)key byValue:(id)value
{
    [[NSUserDefaults standardUserDefaults]setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(void)DeleteUserDefault:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(id)GetUserDefault:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:key];
}

+(id )getSettingValue:(NSString *)key
{
    NSDictionary *dic=[[NSDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle]
                                                                   pathForResource:@"setting"
                                                                   ofType:@"plist"]];
    return [dic objectForKey:key];
}
/*
-(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFStringCreateCopy(NULL, uuidString);
    CFRelease(puuid);
    CFRelease(uuidString);
    return result ;
}
*/
+(NSString *)GetDownloadFilePath:(NSString *)filename
{
    NSString *paths=[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    return ([paths stringByAppendingPathComponent:filename]);
}
+(void)ShowMsgbyTitle:(NSString *)title ByMsg:(NSString *)msg byButtonTitle:(NSString *)buttontitle
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:buttontitle otherButtonTitles:nil];
    [alertView show];
    // [alertView release];
}
//+ (BOOL)isNetwork
//{
//	return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == 0);
//}

//...删除本地文件
+(void)DeleteLocalFile:(NSString*)fileName{
    NSString * filePath = [self GetDownloadFilePath:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([self FileExitsBypath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

+(BOOL)FileExitsBypath:(NSString *)ff
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return ([fileManager fileExistsAtPath: ff]);
}


//保存图片到沙盒Images文件中
+(void)CreateImagesFilePath:(NSString*)imageName withData:(NSData*)data{
    NSString * filePath = [self GetDownloadFilePath:@"Images"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 创建目录
    if (![self FileExitsBypath:filePath]) {
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSLog(@"filePath___%@",[filePath stringByAppendingPathComponent:imageName]);
    [data writeToFile:[filePath stringByAppendingPathComponent:imageName] atomically:YES];
}
//..从沙河中获取图片
+(NSString*)GetImagesFilePath:(NSString*)imageName{
    NSString * filePath = [self GetDownloadFilePath:@"Images"];
    return [filePath stringByAppendingPathComponent:imageName];
}

+(BOOL)checkIdCardNoFunc:(NSString *) identityCard{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}
+(BOOL)checkCityNo:(NSString *)cityNo{
  NSArray *cityCode=[NSArray arrayWithObjects:@"11",@"12",@"13",@"14",@"14",@"15",@"21",@"22",@"23",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"41",@"42",@"43",@"44",@"45",@"46",@"50",@"51",@"52",@"53",@"54",@"61",@"62",@"63",@"64",@"65",@"71",@"81",@"82",@"91", nil];
  for (int i=0; i<[cityCode count]; i++) {
      if ([cityNo isEqual:cityCode[i]]) { 
          return YES; 
      } 
  } 
  return NO; 
  
}

+(NSString *)isCorrectNumber:(NSString *)correctNum
{
    NSString *phoneStr = [correctNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    correctNum = [phoneStr stringByReplacingOccurrencesOfString:@"\\p{Cf}" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, phoneStr.length)];
    
    return  correctNum;
}


/*手机号码验证 MODIFIED BY HELENSONG*/
+(BOOL)isMobileNumber:(NSString *)mobileNum
{    
    NSString *phoneRegex1=@"1[3456789]([0-9]){9}";
    NSPredicate *phoneTest1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex1];
    return  [phoneTest1 evaluateWithObject:mobileNum];
}

/*邮编验证 */
+(BOOL)isPostalNumber:(NSString *)postalNum
{
    NSPredicate* phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[1-9][0-9]{5}$"];
    
    return [phoneTest evaluateWithObject:postalNum];
}

//验证邮箱
+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


+(CGSize)sizeWithFrame:(UIFont *)font toString:(NSString *)string
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize textSize = [string boundingRectWithSize:CGSizeMake(200, 0)  options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return textSize;
}


+(NSString *)getImageUrl:(NSString *)string
{
    return [NSString stringWithFormat:@"http://demo607.firdot.com%@",string];
}

@end
