//
//  BottomPageView.m
//  SZPageControllerDemo
//
//  Created by JimmyYue on 2021/2/6.
//  Copyright © 2021 StenpZ. All rights reserved.
//

#import "BottomPageView.h"

@implementation BottomPageView

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.pageCollectionView registerNib:[UINib nibWithNibName:@"BottomPageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BottomPageCollectionViewCell"];
    self.pageCollectionView.delegate = self;
    self.pageCollectionView.dataSource = self;
    
    _backView.layer.cornerRadius = 15;
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
    [self.hiddenView addGestureRecognizer:tapGesture];
}

- (void)event:(UITapGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(setHidden:)]) {
        [self.delegate setHidden:self];
    }
}

- (void)setReloadCollectionView {
    self.correctLabel.text = @"0";
    self.wrongLabel.text = @"0";
    for (Question*question in self.arrayDate) {
        if (question.chooseArray.count > 0) {
            if (question.correct == YES) {
                self.correctLabel.text = [NSString stringWithFormat:@"%d", [self.correctLabel.text intValue] + 1];
            } else {
                self.wrongLabel.text = [NSString stringWithFormat:@"%d", [self.wrongLabel.text intValue] + 1];
            }
        }
    }
    
    self.pageLabel.text = [NSString stringWithFormat:@"%ld", _index + 1];
    self.totalLabel.text = [NSString stringWithFormat:@" / %ld", self.arrayDate.count];
    [self.pageCollectionView reloadData];
    
    // CollectionView滑动到指定cell
    if (_index > 5) {
        NSIndexPath* cellIndexPath = [NSIndexPath indexPathForRow:_index inSection:0];
        [self.pageCollectionView scrollToItemAtIndexPath:cellIndexPath
                                        atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayDate.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indtifer = @"BottomPageCollectionViewCell";
    BottomPageCollectionViewCell *cell = [self.pageCollectionView dequeueReusableCellWithReuseIdentifier:indtifer forIndexPath:indexPath];
    
    cell.pageTitleLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    
    [cell.layer setBorderWidth:1];
    cell.layer.cornerRadius = ((self.frame.size.width - 105) / 6) / 2;//半径
    
    Question*question = self.arrayDate[indexPath.row];
    if (question.chooseArray.count > 0) {
        if (question.correct == YES) {
            cell.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:248.0/255.0 blue:253.0/255.0 alpha:1];
            [cell.layer setBorderColor:[UIColor colorWithHexString:@"285BF6"].CGColor];
            cell.pageTitleLabel.textColor = [UIColor colorWithHexString:@"285BF6"];
        } else {
            cell.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1];
            [cell.layer setBorderColor:[UIColor redColor].CGColor];
            cell.pageTitleLabel.textColor = [UIColor redColor];
        }
    } else {
        [cell.layer setBorderColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1].CGColor];
        cell.backgroundColor = [UIColor whiteColor];
        cell.pageTitleLabel.textColor = [UIColor blackColor];
        if (indexPath.row == _index) {
            cell.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
        }
    }
    
    return cell;
}

- (BOOL)array:(NSArray *)array1 isEqualTo:(NSArray *)array2 {
    if (array1.count != array2.count) {
        return NO;
    }
    for (NSString *str in array1) {
        if (![array2 containsObject:str]) {
            return NO;
        }
    }
    for (NSString *str in array2) {
        if (![array1 containsObject:str]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark <UICollectionViewDelegate>
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.frame.size.width - 105) / 6, (self.frame.size.width - 105) / 6);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 0, 15, 0);  //分别为上、左、下、右
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {  // 行间距
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {   // 列间距
    return 15;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(setChoose:index:)]) {
        [self.delegate setChoose:self index:indexPath.row];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)submitBtnAction:(id)sender {
}
@end
