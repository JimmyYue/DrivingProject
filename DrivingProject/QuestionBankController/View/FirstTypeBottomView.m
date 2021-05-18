//
//  FirstTypeBottomView.m
//  SZPageControllerDemo
//
//  Created by JimmyYue on 2021/2/7.
//  Copyright © 2021 StenpZ. All rights reserved.
//

#import "FirstTypeBottomView.h"

@implementation FirstTypeBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)nextBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(setNext:)]) {
        [self.delegate setNext:self];
    }
}

- (IBAction)beforeBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(setBefore:)]) {
        [self.delegate setBefore:self];
    }
}

- (IBAction)pageBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(setPage:)]) {
        [self.delegate setPage:self];
    }
}

@end
