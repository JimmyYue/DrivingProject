//
//  TempViewController.h
//  SZPageControllerDemo
//
//  Created by zxc on 2017/5/14.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseTableViewCell.h"
#import "Question.h"
#import "IsBlankString.h"
#import <WebKit/WebKit.h>
#import "ZJPlayerView.h"

@interface TempViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *typeLabel;

- (void)setReloadTableView:(NSInteger)type;

@property (strong, nonatomic) Question *question;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIView *tableFooterView;
@property (nonatomic, assign) float footerViewHeight;
@property (nonatomic, strong) NSMutableArray *arrayDate;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UILabel *explainLabel;
@property (nonatomic, strong) UILabel *answerLabel;
@property (nonatomic, strong) UILabel *explainLabelS;
@property (nonatomic, copy) NSString *title;
@end
