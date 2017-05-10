//
//  FCContactCreationHeaderView.h
//  FastCall
//
//  Created by 和平老三 on 2017/5/8.
//  Copyright © 2017年 zhangyingjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCContactCreationHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *backGroundImageView;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

-(void)updateAvatar:(UIImage *)newAvatar;

@end
