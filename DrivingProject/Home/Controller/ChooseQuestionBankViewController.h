//
//  ChooseQuestionBankViewController.h
//  SZPageControllerDemo
//
//  Created by JimmyYue on 2021/2/19.
//  Copyright © 2021 StenpZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZAreaTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChooseQuestionBankViewController : UIViewController<CLLocationManagerDelegate>

@property (nonatomic, strong) NSString *locationCity;
@property (nonatomic, strong) UIButton *chooseBtn;
@property (nonatomic, strong) NSString *car_type;
@property (nonatomic, strong) NSString *carTypeName;
@property (nonatomic, strong) NSString *carTypeNameS;

@property (strong, nonatomic) IBOutlet UILabel *updateLabel;

@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
- (IBAction)cityBtnAction:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *typeLabel;

@property (strong, nonatomic) IBOutlet UIButton *carBtn;
@property (strong, nonatomic) IBOutlet UIButton *vanBtn;
@property (strong, nonatomic) IBOutlet UIButton *passengerBtn;
@property (strong, nonatomic) IBOutlet UIButton *motorcycleBtn;
@property (strong, nonatomic) IBOutlet UIButton *keBtn;
@property (strong, nonatomic) IBOutlet UIButton *huoBtn;
@property (strong, nonatomic) IBOutlet UIButton *weiBtn;
@property (strong, nonatomic) IBOutlet UIButton *jiaoBtn;
@property (strong, nonatomic) IBOutlet UIButton *wangBtn;
@property (strong, nonatomic) IBOutlet UIButton *chuBtn;

- (IBAction)carTypeAction:(id)sender;

- (IBAction)sureBtnAction:(id)sender;

@property (nonatomic,copy)void (^blockCity)(NSString *city, NSString *type, NSString *name, NSString *nameS);

@end

NS_ASSUME_NONNULL_END
