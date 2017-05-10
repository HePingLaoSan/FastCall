//
//  FCContactCreationViewController.h
//  FastCall
//
//  Created by 和平老三 on 2017/5/8.
//  Copyright © 2017年 zhangyingjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactModel.h"

@class FCContactCreationViewController;

@protocol FCContactCreationDelegate <NSObject>

@optional

-(void)contactCreationViewControllerdidFinishCreationContact:(FCContactCreationViewController *)viewController;

-(void)contactCreationViewControllerdidCancelCreationContact:(FCContactCreationViewController *)viewController;

@end


@interface FCContactCreationViewController : UIViewController



@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) id<FCContactCreationDelegate>delegate;

@property (strong, nonatomic) ContactModel *contactModel;

@end
