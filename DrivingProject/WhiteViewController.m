//
//  WhiteViewController.m
//  DrivingProject
//
//  Created by JimmyYue on 2021/5/17.
//

#import "WhiteViewController.h"

@interface WhiteViewController ()

@end

@implementation WhiteViewController

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    //  触摸空白处隐藏键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"w.jpg"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
}

- (void)setTitle:(NSString *)str {
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.backBtn setTitle:str forState:UIControlStateNormal];
    self.backBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    self.backBtn.frame = CGRectMake(0, 0, 150, 30);
    self.backBtn.adjustsImageWhenHighlighted = NO;
    UIImage *buttonImage = [UIImage  imageNamed:@"back_left"];
    [self.backBtn setImage:buttonImage forState:UIControlStateNormal];
    self.backBtn.userInteractionEnabled = YES;
    [self.backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 120)];
    [self.backBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [self.backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)doBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
