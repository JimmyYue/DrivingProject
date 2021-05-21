//
//  LoginViewController.h
//  DrivingProject
//
//  Created by JimmyYue on 2021/5/17.
//

#import <UIKit/UIKit.h>
#import "YHLTextFieldPhone.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController<YHLTextFieldDelegate, UITextFieldDelegate>

- (IBAction)closeBtnAction:(id)sender;

- (IBAction)xieyiBtnAction:(id)sender;

- (IBAction)zhengceBtnAction:(id)sender;

- (IBAction)selectBtnAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *selectBtn;

@property (strong, nonatomic) IBOutlet YHLTextFieldPhone *phoneText;

@property (strong, nonatomic) IBOutlet UITextField *codeText;

@property (strong, nonatomic) IBOutlet UIButton *codeBtn;

- (IBAction)codeBtnAction:(id)sender;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) int curTime;//倒计时 开始时间

@end

NS_ASSUME_NONNULL_END
