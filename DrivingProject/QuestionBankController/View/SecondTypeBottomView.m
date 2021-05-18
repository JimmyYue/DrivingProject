//
//  SecondTypeBottomView.m
//  SZPageControllerDemo
//
//  Created by JimmyYue on 2021/2/7.
//  Copyright © 2021 StenpZ. All rights reserved.
//

#import "SecondTypeBottomView.h"

@implementation SecondTypeBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    _backView.layer.borderWidth=1;
    _backView.layer.borderColor= [UIColor colorWithHexString:@"285BF6"].CGColor;
    _backView.layer.cornerRadius=17;

    self.count = 60 * 45;
    self.airTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    self.timeBtn.selected = YES;
    [self.airTimer setFireDate:[NSDate distantFuture]];
}

- (void)setNewNSTimer {
    self.count = 60 * 45;
    self.airTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [self setStarTime];
}

- (void)setStarTime {
    self.timeBtn.selected = NO;
    [self.airTimer setFireDate:[NSDate date]];
}

-(void)timerAction:(NSTimer *)time {
    self.count --;
    int minutes = self.count / 60;
    int seconds = self.count % 60;
    NSString *strTime = [NSString stringWithFormat:@"%d:%.2d",minutes, seconds];
    [self.timeBtn setTitle:strTime forState:UIControlStateNormal];
}

- (IBAction)pageBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(setToPage:)]) {
        [self.delegate setToPage:self];
    }
}

- (IBAction)timeBtnAction:(id)sender {
    if (self.timeBtn.selected == NO) {
        self.timeBtn.selected = YES;
        [self.airTimer setFireDate:[NSDate distantFuture]];
    } else {
        self.timeBtn.selected = NO;
        [self.airTimer setFireDate:[NSDate date]];
    }
    if ([self.delegate respondsToSelector:@selector(setTime:selected:)]) {
        [self.delegate setTime:self selected:self.timeBtn.selected];
    }
}

- (IBAction)submitBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(setSubmite:)]) {
        [self.delegate setSubmite:self];
    }
}


@end
