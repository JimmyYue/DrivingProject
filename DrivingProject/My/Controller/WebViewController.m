//
//  WebViewController.m
//  Driving
//
//  Created by JimmyYue on 2021/2/23.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic)  WKWebView* webView;

@end

@implementation WebViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.titleS;
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.webView];
    
    //  加载进度条
    UIView *progress = [[UIView alloc]initWithFrame:CGRectMake(0, self.webView.frame.origin.y - 1, CGRectGetWidth(self.view.frame), 1)];
    progress.backgroundColor = [UIColor clearColor];
    [self.view addSubview:progress];
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 0, 1);
    layer.backgroundColor = [UIColor colorWithHexString:@"285BF6"].CGColor;
    [progress.layer addSublayer:layer];
    self.progresslayer = layer;
    
    [_webView addObserver:self forKeyPath:@"EstimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"EstimatedProgress"]) {
        self.progresslayer.opacity = 1; if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
            return;
        }
        self.progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[@"new"] floatValue], 1);
        if ([change[@"new"] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.frame = CGRectMake(0, 0, 0, 1);
            });
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (WKWebView *)webView {
    if (!_webView) {
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.selectionGranularity = WKSelectionGranularityDynamic;
        config.allowsInlineMediaPlayback = YES;
        WKPreferences *preferences = [WKPreferences new];
        //不通过用户交互，是否可以打开窗口
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preferences;
        
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, StatusRect + NavRect + 1, kDeviceWidth, kDeviceHeight - StatusRect - NavRect - 1) configuration:config];
        self.webView.backgroundColor = [UIColor whiteColor];
        self.webView.navigationDelegate = self;
        self.webView.UIDelegate = self;
        self.webView.opaque = NO;  //背景不透明设置为N
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
        [_webView loadRequest:request];
        
    }
    return _webView;
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
