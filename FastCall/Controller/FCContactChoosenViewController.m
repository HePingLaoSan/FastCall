//
//  FCContactChoosenViewController.m
//  FastCall
//
//  Created by zhangyingjie on 2017/5/8.
//  Copyright © 2017年 zhangyingjie. All rights reserved.
//

#import "FCContactChoosenViewController.h"
#import "FCBaseViewController.h"
#import "FCContactCreationViewController.h"

@interface FCContactChoosenViewController ()<FCContactCreationDelegate>

@end

@implementation FCContactChoosenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeMe)];
    [self.blurView addGestureRecognizer:tap];
    
    self.blurView.effect = nil;
    _createView.alpha = 0.0f;
    _contactView.alpha = 0.0f;
    
    _createView.transform = CGAffineTransformMakeTranslation(0, 100);
    _contactView.transform = CGAffineTransformMakeTranslation(0, 100);

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self performBlurAnimation];
    
    [self performItemsAnimation];
}


-(void)performBlurAnimation{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    [UIView animateWithDuration:0.25 animations:^{
        self.blurView.effect = effect;
    }];
}


-(void)performItemsAnimation{
    _createView.alpha = 0.0f;
    _contactView.alpha = 0.0f;
    [UIView animateWithDuration:1 delay:0.1 usingSpringWithDamping:0.4 initialSpringVelocity:10.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _contactView.alpha = 1.0f;
        _contactView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _createView.alpha = 1.0f;
        _createView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)closeMe{
    [UIView animateWithDuration:0.25 animations:^{
        self.blurView.effect = nil;
        _createView.alpha = 0.0f;
        _contactView.alpha = 0.0f;
    }completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}



- (IBAction)clickContactBtn:(id)sender {

    UINavigationController *homeNav = (UINavigationController *)self.presentingViewController;
    FCBaseViewController *homeVC = [homeNav.viewControllers firstObject];
    [homeVC clickAddBtn:self];
}

- (IBAction)clickNewContact:(id)sender{
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"NewContact"]) {
        UINavigationController *createNav = segue.destinationViewController;
        FCContactCreationViewController *createVC = [createNav.viewControllers firstObject];
        createVC.delegate = self;
        [super prepareForSegue:segue sender:sender];
    }
}

-(void)contactCreationViewControllerdidFinishCreationContact:(FCContactCreationViewController *)viewController{
    UINavigationController *homeNav = (UINavigationController *)self.presentingViewController;
    FCBaseViewController *homeVC = [homeNav.viewControllers firstObject];
    [homeVC refresh];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)contactCreationViewControllerdidCancelCreationContact:(FCContactCreationViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
