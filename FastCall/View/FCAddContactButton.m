//
//  FCAddContactButton.m
//  FastCall
//
//  Created by zhangyingjie on 2017/4/28.
//  Copyright © 2017年 zhangyingjie. All rights reserved.
//

#import "FCAddContactButton.h"

@implementation FCAddContactButton

-(void)startAnimation{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    int rotate = 1;
    self.transform = CGAffineTransformRotate(self.transform, M_PI_4*rotate);
    [UIView commitAnimations];
}


-(void)resetAnimation{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}






@end
