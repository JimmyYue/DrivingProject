//
//  LoginViewController.m
//  DrivingProject
//
//  Created by JimmyYue on 2021/5/17.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.phoneText becomeFirstResponder];  // 编辑状态
    [self.phoneText setFormat:YES];
    self.phoneText.cdelegate = self;
    self.selectBtn.selected = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.codeText && textField.text.length > 3 && ![string isEqualToString:@""]) {
        return NO;
    }
    
    return YES;
}

- (void)startTimer {
    _curTime = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown:) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    [self.timer invalidate];
}

- (void)countdown:(NSTimer *)time {
    _curTime --;
    if (_curTime <= 0) {
        [self.codeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.codeBtn setEnabled:YES];
        [self stopTimer];
    }
    else {
        [self.codeBtn setTitle:[NSString stringWithFormat:@"%d秒",_curTime] forState:UIControlStateNormal];
        [self.codeBtn setEnabled:NO];
    }
}

- (void)dealloc {
    [self stopTimer];
}

- (IBAction)codeBtnAction:(id)sender {
    if ([XYCommon isMobileNumber:_phoneText.yhl_text] == NO) {
        [SVProgressHUD showInfoWithStatus:@"请填写正确的手机号码!"];
    } else {
        [self startTimer];
        
    }
}



- (IBAction)selectBtnAction:(id)sender {
    UIButton *button = sender;
    if (button.selected == NO) {
        self.selectBtn.selected = YES;
    } else {
        self.selectBtn.selected = NO;
    }
}

- (IBAction)zhengceBtnAction:(id)sender {
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.titleS = @"隐私政策";
    webVC.url = @"http://wap.zqwzc.cn/single-page/privacy-policy?platform=jtjktk";
    [self.navigationController pushViewController:webVC animated:YES];
}

- (IBAction)xieyiBtnAction:(id)sender {
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.titleS = @"用户协议";
    webVC.url = @"http://wap.zqwzc.cn/single-page/app-user-protocol?platform=jtjktk";
    [self.navigationController pushViewController:webVC animated:YES];
}

- (IBAction)closeBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
