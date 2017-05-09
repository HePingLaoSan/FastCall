//
//  showSelectionContact.m
//  FastCall
//
//  Created by zhangyingjie on 2017/5/8.
//  Copyright © 2017年 zhangyingjie. All rights reserved.
//

#import "FCShowSelectionContactSegue.h"

@implementation FCShowSelectionContactSegue


-(void)perform{
//    [super perform];
    
    UIViewController *current = self.sourceViewController;
    
    UIViewController *next = self.destinationViewController;
    
    next.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
//    next.view.alpha = 0.0f;
    
    [current presentViewController:next animated:NO completion:^{


    }];
    

    
    
}



@end
