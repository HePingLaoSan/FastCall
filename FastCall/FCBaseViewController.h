//
//  ViewController.h
//  FastCall
//
//  Created by zhangyingjie on 2016/11/28.
//  Copyright © 2016年 zhangyingjie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FCAddContactButton;
@interface FCBaseViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (weak, nonatomic) IBOutlet FCAddContactButton *addContactBtn;
@property (weak, nonatomic) IBOutlet UILabel *emptyInfoLabel;

- (void)clickAddBtn:(UIViewController *)presentedVC;

- (void)refresh;

@end

