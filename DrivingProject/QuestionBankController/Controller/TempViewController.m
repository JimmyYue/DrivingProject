//
//  TempViewController.m
//  SZPageControllerDemo
//
//  Created by zxc on 2017/5/14.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import "TempViewController.h"
#import "UIView+SZPageController.h"
#import "NSURLProtocol+BAWebView.h"
#import "BAURLSessionProtocol.h"


@interface TempViewController ()

@end

@implementation TempViewController

#pragma mark - 注册自定义 NSURLProtocol
- (void)ba_registerURLProtocol {
    // 注册registerScheme使得WKWebView支持NSURLProtocol
    [NSURLProtocol ba_web_registerScheme:@"http"];
    [NSURLProtocol ba_web_registerScheme:@"https"];
}

- (void)dealloc {
    // 移除 registerScheme
    [NSURLProtocol ba_web_unregisterScheme:@"http"];
    [NSURLProtocol ba_web_unregisterScheme:@"https"];
    
    if (_question.state == NO) {
        _question.chooseArray = [NSMutableArray array];
    }
}

- (void)setQuestion:(Question *)question {
        
    _question = question;
    
    float height = 0.0;
    float top = 20.0;
    if ([IsBlankString isBlankString:_question.media_url] == NO) {
        height = 10.0;
        
        NSString *urlStr = [_question.media_url substringFromIndex:_question.media_url.length - 4];
        if ([urlStr isEqualToString:@"webp"]) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, CGRectGetWidth(self.view.bounds) - 30, (CGRectGetWidth(self.view.bounds) - 30) / 2)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _question.media_url]] placeholderImage:[UIImage imageNamed:@"loadImage"]];
            imageView.contentMode = UIViewContentModeScaleAspectFit;  // 图片居中显示
            [self.tableHeaderView addSubview:imageView];
            
        } else {
            
            ZJPlayerView *playerView = [[ZJPlayerView alloc] init];
            playerView.frame = CGRectMake(15, 20, CGRectGetWidth(self.view.bounds) - 30, (CGRectGetWidth(self.view.bounds) - 30) / 2);
            playerView.backgroundColor = [UIColor colorWithHexString:@"F9F9F9"];
            playerView.movieUrl = _question.media_url;
//            playerView.placeholderImage = @"home_logo";
            playerView.cuttentController = self;
            [self.tableHeaderView addSubview:playerView];
            [playerView setPlay];
            
//            WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//            config.selectionGranularity = WKSelectionGranularityCharacter;
//            config.allowsInlineMediaPlayback = NO;
//
//            WKPreferences *preferences = [WKPreferences new];
//            //是否支持JavaScript
//            preferences.javaScriptEnabled = YES;
//            //不通过用户交互，是否可以打开窗口
//            preferences.javaScriptCanOpenWindowsAutomatically = YES;
//            config.preferences = preferences;
//
//            self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(15, 20, CGRectGetWidth(self.view.bounds) - 30, (CGRectGetWidth(self.view.bounds) - 30) / 2) configuration:config];
//            self.webView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
//            self.webView.navigationDelegate = self;
//            self.webView.UIDelegate = self;
//            self.webView.opaque = NO;  //背景不透明设置为N
//
//            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _question.media_url]]];
//            [self.webView loadRequest:request];
//
//            [self.tableHeaderView addSubview:self.webView];
        }
        top = (CGRectGetWidth(self.view.bounds) - 30) / 2 + 35.0;
    }
    
    NSString *str;
    if ([self.title isEqualToString:@"随机练习"] || [self.title isEqualToString:@"答错试题"] || [self.title isEqualToString:@"未做练习"] ) {
        str = [NSString stringWithFormat:@"             %@",  _question.question];
    } else {
        str = [NSString stringWithFormat:@"             %ld.%@", (long)_question.index,  _question.question];
    }
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:18]};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 30, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    NSMutableAttributedString *attContentStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attContentStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, top, CGRectGetWidth(self.view.bounds) - 30, rect.size.height + 5 + (rect.size.height / 20 - 1) * 4)];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.attributedText = attContentStr;
        [self.titleLabel sizeToFit];
        [self.tableHeaderView addSubview:self.titleLabel];
        
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, top + 1, 50, 20)];
    self.typeLabel.backgroundColor = [UIColor colorWithHexString:@"285BF6"];
        self.typeLabel.textColor = [UIColor whiteColor];
        self.typeLabel.font = [UIFont systemFontOfSize:13];
        [self.typeLabel.layer setMasksToBounds:YES];
        [self.typeLabel.layer setCornerRadius:3.0];
        if ([_question.option_type isEqualToString:@"0"]) {
            self.typeLabel.text = @"判断题";
        } else if ([_question.option_type isEqualToString:@"1"]) {
            self.typeLabel.text = @"单选题";
        } else if ([_question.option_type isEqualToString:@"2"]) {
            self.typeLabel.text = @"多选题";
        }
        self.typeLabel.textAlignment = NSTextAlignmentCenter;
        [self.tableHeaderView addSubview:self.typeLabel];
    
    self.tableHeaderView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), rect.size.height + (rect.size.height / 20 - 1) * 4 + 10 + height + top);
    
    NSArray *array = @[@"A", @"B", @"C", @"D", @"E", @"F"];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL *     _Nonnull stop) {
        if ([[_question.choose allKeys] containsObject:obj]) {
            [self.arrayDate addObject:obj];
        }
    }];
    
    //  已选择 或 背题
    if (_question.state == YES || _question.topicType == 2) {
        [self tableViewFooterView];
    }

    //  没有图片时
//    if ([IsBlankString isBlankString:_question.media_url] == YES) {
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 162 - StatusRect);
        [self.tableView reloadData];
//    }
}

//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    [webView evaluateJavaScript:@"document.body.offsetWidth;" completionHandler:^(id Result, NSError * error) {
//        NSString *widthStr = [NSString stringWithFormat:@"%@", Result];
//        CGFloat width = widthStr.floatValue;
//        [webView evaluateJavaScript:@"document.body.offsetHeight;" completionHandler:^(id Result, NSError * error) {
//            NSString *heightStr = [NSString stringWithFormat:@"%@", Result];
//            CGFloat height = heightStr.floatValue;
//            self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//            self.webView.frame = CGRectMake(15, 20, CGRectGetWidth(self.view.bounds) - 30, ((CGRectGetWidth(self.view.bounds) - 30) / width) * height);
//            self.titleLabel.frame = CGRectMake(15, self.webView.frame.size.height + 35, CGRectGetWidth(self.view.bounds) - 30, self.titleLabel.frame.size.height);
//            self.typeLabel.frame = CGRectMake(15, self.webView.frame.size.height + 36, 50, 20);
//            self.tableHeaderView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), self.tableHeaderView.frame.size.height + (((CGRectGetWidth(self.view.bounds) - 30) / width) * height) - (CGRectGetWidth(self.view.bounds) - 30) /2);
//            [self.tableView reloadData];
//        }];
//    }];
//}

- (void)setReloadTableView:(NSInteger)type {
    _question.topicType = type;
    if (_question.topicType == 1) {  // 答题模式
        if (_question.state == NO) {  //未选择
            if (_explainLabel) {
                _explainLabel.hidden = YES;
                _answerLabel.hidden = YES;
                _explainLabelS.hidden = YES;
                self.tableFooterView.frame = CGRectMake(0, 0, self.view.frame.size.width, 80);
            }
            self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.tableView reloadData];
        } else {
            //  已选择
            self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.tableView reloadData];
        }
    } else {  // 背题模式
        if (_explainLabel) {  // 已创建底部解释
            _explainLabel.hidden = NO;
            _answerLabel.hidden = NO;
            _explainLabelS.hidden = NO;
            self.tableFooterView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), _footerViewHeight);
        } else {  // 未创建底部解释
            self.sureBtn.hidden = YES;
            [self tableViewFooterView];
        }
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ba_registerURLProtocol];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.arrayDate = [[NSMutableArray alloc] init];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    self.tableHeaderView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    float heightF = 0;
    if ([self.title isEqualToString:@"模拟考试"] || [_question.option_type isEqualToString:@"2"]) {
        heightF = 80;
    }
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, heightF)];
    self.tableFooterView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = self.tableFooterView;
    
    if ([self.title isEqualToString:@"模拟考试"]) {
        [self setSureBtn];
    } else {
        //  多选时
        if ([_question.option_type isEqualToString:@"2"]) {
            [self setSureBtn];
            self.sureBtn.hidden = YES;
        }
    }
}

- (void)setSureBtn {
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sureBtn.frame = CGRectMake(CGRectGetWidth(self.view.bounds) / 2 - 90, 30, 180, 40);
    [self.sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sureBtn.backgroundColor = [UIColor colorWithHexString:@"285BF6"];
    [self.sureBtn.layer setMasksToBounds:YES];
    [self.sureBtn.layer setCornerRadius:20.0];
    self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.tableFooterView addSubview:self.sureBtn];
}

- (void)sureBtnAction {
    if ([self.title isEqualToString:@"模拟考试"]) {
        if ([_question.option_type isEqualToString:@"1"] || [_question.option_type isEqualToString:@"0"]) {
            if (_question.chooseArray.count > 0) {
                self.sureBtn.hidden = NO;
                _question.state = YES;
                [self tableViewFooterView];
                self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                [self.tableView reloadData];
                [self setReloadRightBtn];
            }
        } else {
            [self setAlert];
        }
    } else {
        [self setAlert];
    }
}

- (void)setReloadRightBtn {
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        if (self->_question.correct == NO) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadNotification" object:nil userInfo:@{@"count":@"-1"}];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadNotification" object:nil userInfo:@{@"count":@"1"}];
        }
    });
}

- (void)setAlert {
    if (_question.chooseArray.count < 2) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"多选题至少选两项 !" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:YES completion:^{ }];
    } else {
        self.sureBtn.hidden = NO;
        _question.state = YES;
        [self tableViewFooterView];
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.tableView reloadData];
        [self setReloadRightBtn];
    }
}


//  设置表上有几个区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//  每个分区cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayDate.count;
}

//  cell的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *str = @"ChooseTableViewCell";
    ChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ChooseTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    
    [cell.typeBtn setTitle:self.arrayDate[indexPath.row] forState:UIControlStateNormal];
    cell.typeBtn.layer.masksToBounds = YES;
    cell.typeBtn.layer.borderWidth = 1;
    cell.typeBtn.layer.borderColor = [[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1] CGColor];
    
    NSMutableAttributedString *attContentStr = [[NSMutableAttributedString alloc] initWithString:_question.choose[self.arrayDate[indexPath.row]]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attContentStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_question.choose[self.arrayDate[indexPath.row]] length])];
    cell.titleLabel.attributedText = attContentStr;
    [cell.titleLabel sizeToFit];
    
    if (_question.topicType == 2) {
        BOOL isbool = [_question.answerS containsObject:self.arrayDate[indexPath.row]];
        if (isbool == YES) {
            cell.typeBtn.backgroundColor = [UIColor colorWithHexString:@"285BF6"];
            [cell.typeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.typeBtn setTitle:@"✓" forState:UIControlStateNormal];
            [cell.typeBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
            cell.typeBtn.layer.borderWidth = 0;
            cell.titleLabel.textColor = [UIColor colorWithHexString:@"285BF6"];
        }
    } else {
        if (_question.state == YES) {
            BOOL isbool = [_question.answerS containsObject:self.arrayDate[indexPath.row]];
            if (isbool == YES) {
                if ([_question.option_type isEqualToString:@"2"] && _question.correct == NO) {
                    _question.correct = NO;
                } else {
                    _question.correct = YES;
                }
                cell.typeBtn.backgroundColor = [UIColor colorWithHexString:@"285BF6"];
                [cell.typeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [cell.typeBtn setTitle:@"✓" forState:UIControlStateNormal];
                [cell.typeBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
                cell.typeBtn.layer.borderWidth = 0;
                cell.titleLabel.textColor = [UIColor colorWithHexString:@"285BF6"];
                //  正确答案在选择的选项中没有
                BOOL isboolS = [_question.chooseArray containsObject:self.arrayDate[indexPath.row]];
                if (isboolS == NO) {
                    _question.correct = NO;
                }
            } else {
                BOOL isbool = [_question.chooseArray containsObject:self.arrayDate[indexPath.row]];
                if (isbool == YES) {
                    _question.correct = NO;
                    cell.typeBtn.backgroundColor = [UIColor redColor];
                    [cell.typeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [cell.typeBtn setTitle:@"✕" forState:UIControlStateNormal];
                    [cell.typeBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
                    cell.typeBtn.layer.borderWidth = 0;
                    cell.titleLabel.textColor = [UIColor redColor];
                }
            }
        } else {
            BOOL isbool = [_question.chooseArray containsObject:self.arrayDate[indexPath.row]];
            if (isbool == YES) {
                cell.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
            }
        }
    }
    
    //  取消cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_question.topicType != 2) {
        
        if ([self.title isEqualToString:@"模拟考试"]) {
            if (_question.state == NO) {
                if (! _question.chooseArray) {
                    _question.chooseArray = [[NSMutableArray alloc] init];
                }
                ChooseTableViewCell *cell = ( ChooseTableViewCell  *)[tableView cellForRowAtIndexPath:indexPath];
                if ([_question.option_type isEqualToString:@"1"] || [_question.option_type isEqualToString:@"0"]) {
                    _question.chooseArray = [NSMutableArray array];
                    [_question.chooseArray addObject:cell.typeBtn.titleLabel.text];
                    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                    [self.tableView reloadData];
                } else {
                    BOOL isbool = [_question.chooseArray containsObject:cell.typeBtn.titleLabel.text];
                    if (isbool == YES) {
                        [_question.chooseArray removeObject:cell.typeBtn.titleLabel.text];
                        cell.backgroundColor = [UIColor whiteColor];
                    } else {
                        [_question.chooseArray addObject:cell.typeBtn.titleLabel.text];
                        cell.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
                    }
                }
            }
        } else {
            if (_question.state == NO) {
                if (! _question.chooseArray) {
                    _question.chooseArray = [[NSMutableArray alloc] init];
                }
                ChooseTableViewCell *cell = ( ChooseTableViewCell  *)[tableView cellForRowAtIndexPath:indexPath];
                if ([_question.option_type isEqualToString:@"1"] || [_question.option_type isEqualToString:@"0"]) {
                    [_question.chooseArray addObject:cell.typeBtn.titleLabel.text];
                    _question.state = YES;
                    [self tableViewFooterView];
                    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                    [self.tableView reloadData];
                    [self setReloadRightBtn];
                } else {
                    BOOL isbool = [_question.chooseArray containsObject:cell.typeBtn.titleLabel.text];
                    if (isbool == YES) {
                        [_question.chooseArray removeObject:cell.typeBtn.titleLabel.text];
                        cell.backgroundColor = [UIColor whiteColor];
                        if (_question.chooseArray.count == 0) {
                            self.sureBtn.hidden = YES;
                        }
                    } else {
                        [_question.chooseArray addObject:cell.typeBtn.titleLabel.text];
                        cell.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
                        self.sureBtn.hidden = NO;
                    }
                }
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *str = [NSString stringWithFormat:@"%@", _question.choose[self.arrayDate[indexPath.row]]];
    
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:15]};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 64, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    if (rect.size.height > 18) {
        return rect.size.height + 33;
    } else {
        return 48;
    }
}

- (void)tableViewFooterView {
    
    if (_question.state == YES) {
        self.sureBtn.hidden = YES;
    }
    
    _explainLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(self.view.bounds), 20)];
    _explainLabel.textColor = [UIColor colorWithHexString:@"C8C8C8"];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"———   试题详解   ———"];
    NSRange range1 = [[str string] rangeOfString:@"试题详解"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range1];
    _explainLabel.attributedText = str;
    _explainLabel.font = [UIFont systemFontOfSize:15];
    _explainLabel.textAlignment = NSTextAlignmentCenter;
    [self.tableFooterView addSubview:_explainLabel];
    
    _answerLabel  = [[UILabel alloc] initWithFrame:CGRectMake(15, _explainLabel.frame.origin.y + _explainLabel.frame.size.height + 15, CGRectGetWidth(self.view.bounds) - 30, 20)];
    _answerLabel.text = @"答案 :";
    for (NSString * str in _question.answerS) {
        _answerLabel.text = [NSString stringWithFormat:@"%@ %@", _answerLabel.text, str];
    }
    _answerLabel.font = [UIFont systemFontOfSize:15];
    [self.tableFooterView addSubview:_answerLabel];
    
    NSString *strC = [NSString stringWithFormat:@"%@", [self gainString:_question.explain]];
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:15]};
    CGRect rect = [strC boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 30, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    NSMutableAttributedString *attContentStr = [[NSMutableAttributedString alloc] initWithString:strC];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    [attContentStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [strC length])];
    
    NSNumber *count = @((rect.size.height) / 15);
    
    _explainLabelS = [[UILabel alloc] initWithFrame:CGRectMake(15, _answerLabel.frame.origin.y + _answerLabel.frame.size.height + 10, CGRectGetWidth(self.view.bounds) - 30, rect.size.height + [count floatValue] * 10)];
    _explainLabelS.font = [UIFont systemFontOfSize:15];
    _explainLabelS.textColor = [UIColor colorWithRed:80.0/255.0 green:80.0/255.0 blue:80.0/255.0 alpha:1];
    _explainLabelS.numberOfLines = 0;
    _explainLabelS.attributedText = attContentStr;
    [_explainLabelS sizeToFit];
    [self.tableFooterView addSubview:_explainLabelS];
    
    self.tableFooterView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 100 + rect.size.height + [count floatValue] * 10);
    
    _footerViewHeight = 100 + rect.size.height + [count floatValue] * 10;
}


- (NSString *)gainString:(NSString *)string
{
    NSString *result = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
    return result;
}

@end
