//
//  MyViewController.m
//  Driving
//
//  Created by JimmyYue on 2021/2/21.
//

#import "MyViewController.h"

@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.myTopView = [[NSBundle mainBundle] loadNibNamed:@"MyTopView" owner:nil options:nil][0];
    self.myTopView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.myTopView];
    
    self.myTopView.versionLabel.text = [self getTheCurrentVersion];
    
    [self.myTopView.clearBtn addTarget:self action:@selector(clearBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.myTopView.agreementBtn addTarget:self action:@selector(agreementBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.myTopView.policyBtn addTarget:self action:@selector(policyBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)agreementBtnAction {
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.titleS = @"用户协议";
    webVC.url = @"http://wap.zqwzc.cn/single-page/app-user-protocol?platform=jtjktk";
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)policyBtnAction {
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.titleS = @"隐私政策";
    webVC.url = @"http://wap.zqwzc.cn/single-page/privacy-policy?platform=jtjktk";
    [self.navigationController pushViewController:webVC animated:YES];
}


//  获取版本号
- (NSString *)getTheCurrentVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef) (infoDictionary));
    NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return currentVersion;
}

- (void)clearBtnAction {
    NSString *string = [NSString stringWithFormat:@"一共有%.2fM缓存",[self filePath]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"清除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self clearFile];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

// 显示缓存大小
-( float )filePath {
    NSString * cachPath = [NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    return [ self folderSizeAtPath :cachPath];
}

//1:首先我们计算一下 单个文件的大小
- ( long long ) fileSizeAtPath:( NSString *) filePath{
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if ([manager fileExistsAtPath :filePath]) {
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    return 0 ;
}

//2:遍历文件夹获得文件夹大小，返回多少 M（提示：你可以在工程界设置（)m）
- ( float ) folderSizeAtPath:( NSString *) folderPath{
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0 );
}

// 清理缓存
- (void)clearFile {
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    NSLog ( @"cachpath = %@" , cachPath);
    for ( NSString * p in files) {
        NSError * error = nil ;
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
        }
    }
    [ self performSelectorOnMainThread : @selector (clearCachSuccess) withObject : nil waitUntilDone : YES ];
}

-(void)clearCachSuccess {
    [SVProgressHUD showSuccessWithStatus:@"清理成功!"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
