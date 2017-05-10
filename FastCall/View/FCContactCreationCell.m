//
//  FCContactCreationCell.m
//  FastCall
//
//  Created by 和平老三 on 2017/5/8.
//  Copyright © 2017年 zhangyingjie. All rights reserved.
//

#import "FCContactCreationCell.h"

@implementation FCContactCreationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _lineView.alpha = 0.0f;
    
    _lineView.transform = CGAffineTransformMakeScale(0.3, 0);
}

-(void)prepareForReuse{
    [super prepareForReuse];
    
    _lineView.alpha = 0.0f;
    
    _lineView.transform = CGAffineTransformMakeScale(0.1, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)performAnimation{

    [UIView animateWithDuration:1.5 animations:^{
       
        _lineView.alpha = 1.0f;
        
        _lineView.transform = CGAffineTransformIdentity;
        
    }];
    
    
}



@end
