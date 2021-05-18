//
//  ChooseQuestionBankViewController.m
//  SZPageControllerDemo
//
//  Created by JimmyYue on 2021/2/19.
//  Copyright © 2021 StenpZ. All rights reserved.
//

#import "ChooseQuestionBankViewController.h"

@interface ChooseQuestionBankViewController ()

@end

@implementation ChooseQuestionBankViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self.car_type isEqualToString:@"car"]) {
        self.chooseBtn = self.carBtn;
    } else if ([self.car_type isEqualToString:@"truck"]) {
        self.chooseBtn = self.vanBtn;
    } else if ([self.car_type isEqualToString:@"bus"]) {
        self.chooseBtn = self.passengerBtn;
    } else if ([self.car_type isEqualToString:@"moto"]) {
        self.chooseBtn = self.motorcycleBtn;
    } else if ([self.car_type isEqualToString:@"keyun"]) {
        self.chooseBtn = self.keBtn;
    } else if ([self.car_type isEqualToString:@"huoyun"]) {
        self.chooseBtn = self.huoBtn;
    } else if ([self.car_type isEqualToString:@"weixian"]) {
        self.chooseBtn = self.weiBtn;
    } else if ([self.car_type isEqualToString:@"jiaolian"]) {
        self.chooseBtn = self.jiaoBtn;
    } else if ([self.car_type isEqualToString:@"wangyue"]) {
        self.chooseBtn = self.wangBtn;
    } else if ([self.car_type isEqualToString:@"chuzu"]) {
        self.chooseBtn = self.chuBtn;
    }
    
    self.chooseBtn.backgroundColor = [UIColor colorWithRed:40/255.0 green:91/255.0 blue:246/255.0 alpha:0.05];
    self.chooseBtn.layer.borderColor = [UIColor colorWithRed:40/255.0 green:91/255.0 blue:246/255.0 alpha:0.5].CGColor;
    
    if ([IsBlankString isBlankString:_locationCity] == NO) {
        _cityLabel.text = _locationCity;
    }
    
}

- (IBAction)cityBtnAction:(id)sender {
    WZAreaTableViewController *cityVC = [[WZAreaTableViewController alloc] init];
    cityVC.titleS = @"选择城市";
    cityVC.locationCity = self.cityLabel.text;
    [cityVC setBlockCity:^(NSString *city) {
        if ([city containsString:@"市"]) {
            self.cityLabel.text = city;
        } else {
            self.cityLabel.text = [NSString stringWithFormat:@"%@市", city];
        }
    }];
    [self.navigationController pushViewController:cityVC animated:YES];
}

- (IBAction)carTypeAction:(id)sender {
    if (self.chooseBtn) {
        self.chooseBtn.backgroundColor = [UIColor clearColor];
        self.chooseBtn.layer.borderColor = [UIColor clearColor].CGColor;
    }
    UIButton *button = sender;
    self.chooseBtn = button;
    self.chooseBtn.backgroundColor = [UIColor colorWithRed:40/255.0 green:91/255.0 blue:246/255.0 alpha:0.05];
    self.chooseBtn.layer.borderColor = [UIColor colorWithRed:40/255.0 green:91/255.0 blue:246/255.0 alpha:0.5].CGColor;
    
    if (button.tag == 210) {
        self.carTypeName = @"小车";
        self.carTypeNameS = @"C1/C2/C3";
        self.car_type = @"car";
    } else if (button.tag == 211) {
        self.carTypeName = @"货车";
        self.carTypeNameS = @"A2/B2";
        self.car_type = @"truck";
    } else if (button.tag == 212) {
        self.carTypeName = @"客车";
        self.carTypeNameS = @"A1/A3/B1";
        self.car_type = @"bus";
    } else if (button.tag == 213) {
        self.carTypeName = @"摩托车";
        self.carTypeNameS = @"D/E/F";
        self.car_type = @"moto";
    } else if (button.tag == 214) {
        self.carTypeName = @"客运";
        self.carTypeNameS = @"";
        self.car_type = @"keyun";
    } else if (button.tag == 215) {
        self.carTypeName = @"货运";
        self.carTypeNameS = @"";
        self.car_type = @"huoyun";
    } else if (button.tag == 216) {
        self.carTypeName = @"危险品";
        self.carTypeNameS = @"";
        self.car_type = @"weixian";
    } else if (button.tag == 217) {
        self.carTypeName = @"教练员";
        self.carTypeNameS = @"";
        self.car_type = @"jiaolian";
    } else if (button.tag == 218) {
        self.carTypeName = @"网约车";
        self.carTypeNameS = @"";
        self.car_type = @"wangyue";
    } else if (button.tag == 219) {
        self.carTypeName = @"出租车";
        self.carTypeNameS = @"";
        self.car_type = @"chuzu";
    }
    self.typeLabel.text = [NSString stringWithFormat:@"驾驶证/资格证(当前类型 : %@)", self.carTypeName];
}

- (IBAction)sureBtnAction:(id)sender {
    self.blockCity(self.cityLabel.text, self.car_type, self.carTypeName, self.carTypeNameS);
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
