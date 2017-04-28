//
//  FastCallCell.m
//  FastCall
//
//  Created by zhangyingjie on 2016/11/28.
//  Copyright © 2016年 zhangyingjie. All rights reserved.
//

#import "FastCallCell.h"
#import "ContactModel.h"

@implementation FastCallCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    _callImageView.layer.masksToBounds =YES;
    _callImageView.contentMode = UIViewContentModeScaleAspectFit;
}


-(void)layoutSubviews{
    _callImageView.layer.cornerRadius = CGRectGetWidth(_callImageView.frame)/2;
}

-(void)configModel:(ContactModel *)contactModel{
    
    self.contactName.text = contactModel.contact_name;
    //add default avatar
    UIImage *image = [UIImage imageWithData:contactModel.contact_thumbnail];
    self.callImageView.image = image;
}

-(void)configViewInEdit:(BOOL)inEdit{
    _callImageView.layer.masksToBounds =YES;
    _callImageView.contentMode = UIViewContentModeScaleAspectFit;
    _callImageView.layer.cornerRadius = CGRectGetWidth(_callImageView.frame)/2;
    if (inEdit) {
        _deleteBtn.alpha = 1.0f;
        CABasicAnimation *animation = (CABasicAnimation *)[_callImageView.layer animationForKey:@"rotation"];
        
        if (animation == nil) {
            
            [self shakeImage:self];
            
        }else {
            
            [self resume:self];
            
        }
    }else{
        _deleteBtn.alpha = 0.0f;
    }
}
- (void)shakeImage:(FastCallCell *)cell {
    
    //创建动画对象,绕Z轴旋转
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //设置属性，周期时长
    
    [animation setDuration:0.08];
    
    //抖动角度
    
    animation.fromValue = @(-M_1_PI/2);
    
    animation.toValue = @(M_1_PI/2);
    
    //重复次数，无限大
    
    animation.repeatCount = HUGE_VAL;
    
    //恢复原样
    
    animation.autoreverses = YES;
    
    //锚点设置为图片中心，绕中心抖动
    
    _callImageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    [_callImageView.layer addAnimation:animation forKey:@"rotation"];
    
}

- (void)resume:(FastCallCell *)cell {
    
    _callImageView.layer.speed = 1.0;
    
}
@end
