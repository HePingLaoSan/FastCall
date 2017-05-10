//
//  FCContactCreationHeaderView.m
//  FastCall
//
//  Created by 和平老三 on 2017/5/8.
//  Copyright © 2017年 zhangyingjie. All rights reserved.
//

#import "FCContactCreationHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation FCContactCreationHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    _headerImageView.layer.masksToBounds = YES;
    
    _headerImageView.layer.cornerRadius = _headerImageView.frame.size.width / 2;
}


-(void)updateAvatar:(UIImage *)newAvatar{
    
    self.headerImageView.image = newAvatar;
    
    self.backGroundImageView.image = newAvatar;
}

@end
