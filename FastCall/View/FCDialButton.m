//
//  FCDialButton.m
//  FastCall
//
//  Created by 和平老三 on 2017/5/23.
//  Copyright © 2017年 zhangyingjie. All rights reserved.
//

#import "FCDialButton.h"

@implementation FCDialButton{
    BOOL hasSelected;
    UIImageView *cycleImageView;
    BOOL isAnimating;
}

-(instancetype)createButton{
    FCDialButton *button = [FCDialButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(buttonHasSelected:) forControlEvents:UIControlEventTouchUpInside];
    cycleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    cycleImageView.alpha = 0.0f;
    cycleImageView.image = [UIImage imageNamed:@"DialCycle"];
    [button addSubview:cycleImageView];
    isAnimating = NO;
    return button;
}
-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)buttonHasSelected:(FCDialButton *)button{
    if (isAnimating == NO) {
        isAnimating = YES;
        [self performAnimation];
    }
}

-(void)performAnimation{
    cycleImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    cycleImageView.alpha = 0.0f;
    cycleImageView.center = CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [UIView animateWithDuration:0.1 animations:^{
        cycleImageView.transform = CGAffineTransformIdentity;
        cycleImageView.alpha = 0.8f;
    }completion:^(BOOL finished) {
        isAnimating = NO;
    }];
}



@end
