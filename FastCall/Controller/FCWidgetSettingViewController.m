//
//  FCWidgetSettingViewController.m
//  FastCall
//
//  Created by 和平老三 on 2017/5/3.
//  Copyright © 2017年 zhangyingjie. All rights reserved.
//

#import "FCWidgetSettingViewController.h"
#import "FCWidgetSettingManager.h"

@interface FCWidgetSettingViewController ()
{
    FCWidgetSettingManager *widgetSettingManager;
}

@end

@implementation FCWidgetSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    widgetSettingManager = [[FCWidgetSettingManager alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidAppear:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:1 animations:^{
        [self performTitleAnimation];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0f animations:^{
            [self performSubTitleAnimation];
            [self.view layoutIfNeeded];
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:1.0f animations:^{
                [self performIndicateImageViewAnimation];
                [self.view layoutIfNeeded];
            }completion:^(BOOL finished) {
                //imageview开始播放动画
                
            }];
        }];
    }];
    if ([FCWidgetSettingManager checkWidgetInstalled]) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIAlertController *alertC = [[UIAlertController alloc]init];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"设置成功" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertC addAction:alertAction];
            [self presentViewController:alertC animated:YES completion:^{
                
            }];
            //您已添加widget 去设置联系人
            UIStoryboard *storyboard = self.view.window.rootViewController.storyboard;
            UIViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainPage"];
            
        });
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

    [self initialAnimationPara];
}

-(void)performTitleAnimation{
    _titleLabel.transform = CGAffineTransformIdentity;
    _titleLabel.alpha = 1.f;
}

-(void)performSubTitleAnimation{
    _subTitleLabel.transform = CGAffineTransformIdentity;
    _subTitleLabel.alpha = 1.0f;
}

-(void)performIndicateImageViewAnimation{
    _indicateImageView.transform = CGAffineTransformIdentity;
    _indicateImageView.alpha = 1.0f;
}

-(void)resetAnimation{
    _titleLabel.transform = CGAffineTransformIdentity;
    _subTitleLabel.transform = CGAffineTransformIdentity;
    _indicateImageView.transform = CGAffineTransformIdentity;
    _titleLabel.alpha = 1.f;
    _subTitleLabel.alpha = 1.0f;
    _indicateImageView.alpha = 1.0f;
}

-(void)initialAnimationPara{
    _titleLabel.transform = CGAffineTransformMakeTranslation(0, [[UIScreen mainScreen]bounds].size.height/2 -100);
    _titleLabel.alpha = 0.3f;
    
    _subTitleLabel.transform = CGAffineTransformMakeTranslation(0, [[UIScreen mainScreen]bounds].size.height/2-50);
    _subTitleLabel.alpha = 0.0f;
    

    _indicateImageView.transform = CGAffineTransformMakeTranslation(0, [[UIScreen mainScreen]bounds].size.height/2);
    _indicateImageView.alpha = 0.0f;
    
}

@end