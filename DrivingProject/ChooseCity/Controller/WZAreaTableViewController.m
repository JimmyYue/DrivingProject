//
//  WZAreaTableViewController.m
//  12123_Example
//
//  Created by che on 2018/9/17.
//  Copyright © 2018年 272789124@qq.com. All rights reserved.
//

#import "WZAreaTableViewController.h"
#import "WZCarCityTableViewCell.h"
#import "UIView+WZXibView.h"
#import "WZHomeAreaTableHeaderView.h"

@interface WZAreaTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSArray *charactersArr;
@property (nonatomic, strong) NSArray *indexArray;
@property (nonatomic, strong) NSArray *sectionItemsArr;

@end

@implementation WZAreaTableViewController



- (UITableView *)mainTableView {
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _mainTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        
        UINib *nib = [UINib nibWithNibName:@"WZCarCityTableViewCell" bundle:nil];
        if (nib) {
            [_mainTableView registerNib:nib forCellReuseIdentifier:@"WZCarCityTableViewCell"];
        }
    }
    return _mainTableView;
}

- (NSArray *)charactersArr {
    if (!_charactersArr) {
        NSMutableArray *toBeReturned = [[NSMutableArray alloc] init];
        for (char c = 'A'; c <= 'Z'; c ++) {
            [toBeReturned addObject:[NSString stringWithFormat:@"%c",c]];
        }
        _charactersArr = [toBeReturned copy];
    }
    return _charactersArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择城市";
    
    [self.view addSubview:self.mainTableView];
    
    WZHomeAreaTableHeaderView *headerView = [WZHomeAreaTableHeaderView initWithXibWithFrame:CGRectMake(0, 0, kDeviceWidth, 242)];
    headerView.selfView = self;
    headerView.locationCity = self.locationCity;
    [headerView setBlockCity:^(NSString *city) {
        self.blockCity(city);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    _mainTableView.tableHeaderView = headerView;
    [self loadCarData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _mainTableView.tableHeaderView.frame = CGRectMake(0, 0, kDeviceWidth, 242);
}

- (void)loadCarData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cityData" ofType:@"plist"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    
    [self refreshTableview:data];
}

- (void)refreshTableview:(NSDictionary *)data {
    NSMutableArray *sectionItems = [[NSMutableArray alloc] init];
    NSMutableArray *indexArray = [[NSMutableArray alloc] init];
    for (NSString *name in self.charactersArr) {
        NSArray *items = data[name.lowercaseString];
        if (items.count > 0) {
            [sectionItems addObject:items];
            [indexArray   addObject:name];
        }
    }
    self.sectionItemsArr = sectionItems;
    self.indexArray = indexArray;
    [self.mainTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionItemsArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.sectionItemsArr[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentify = @"WZCarCityTableViewCell";
    WZCarCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [WZCarCityTableViewCell initwithXib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSArray *array = self.sectionItemsArr[indexPath.section];
    cell.titleLabel.text = array[indexPath.row][@"name"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.indexArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSInteger count = 0;
    for (NSString *character in self.indexArray) {
        if ([character isEqualToString:title]) {
            return count;
        }
        count ++;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if([self.indexArray count] == 0) {
        return @"";
    }
    return [self.indexArray objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 24;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.sectionItemsArr[indexPath.section][indexPath.row];
    self.blockCity(dict[@"name"]);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
