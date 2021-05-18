//
//  WZCarCityTableViewCell.m
//  12123_Example
//
//  Created by che on 2018/8/27.
//  Copyright © 2018年 272789124@qq.com. All rights reserved.
//

#import "WZCarCityTableViewCell.h"

@interface WZCarCityTableViewCell()



@end

@implementation WZCarCityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
     self.selectionStyle=UITableViewCellSelectionStyleNone;
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    //动画高亮变色效果
    [UIView animateWithDuration:0.3 animations:^{
        if(highlighted){
            self.contentView.backgroundColor = [UIColor colorWithHexString:@"F7F7F8"];
        }else{
            self.contentView.backgroundColor = [UIColor whiteColor];
        }
    }];
}

+(instancetype)initwithXib{
    return  [[[NSBundle mainBundle] loadNibNamed:@"SACarTableViewCell" owner:nil options:nil] firstObject];
}

@end
