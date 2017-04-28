//
//  FastCallCell.h
//  FastCall
//
//  Created by zhangyingjie on 2016/11/28.
//  Copyright © 2016年 zhangyingjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FastCallCell,ContactModel;


@interface FastCallCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *callImageView;

@property (weak, nonatomic) IBOutlet UILabel *contactName;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

-(void)configModel:(ContactModel *)contactModel;

-(void)configViewInEdit:(BOOL)inEdit;

@end
