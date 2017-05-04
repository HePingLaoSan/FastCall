//
//  FCSettingViewController.m
//  FastCall
//
//  Created by zhangyingjie on 2017/4/28.
//  Copyright © 2017年 zhangyingjie. All rights reserved.
//

#import "FCSettingViewController.h"
#import <MessageUI/MessageUI.h>

@interface FCSettingViewController ()<MFMailComposeViewControllerDelegate,UITableViewDelegate, UITableViewDataSource>
{
    UITableView *myTableView;
    NSArray *settingArray;
}
@end

@implementation FCSettingViewController

static NSString * const cellIdentifier = @"cellIdentifier";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50+20, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-50-20) style:UITableViewStyleGrouped];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    [myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    settingArray = @[
//  @[@"查看教程"],
  @[@"意见反馈"],
  @[@"关于"],];
}


#pragma mark - UITableViewDelegate & DataSources
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return settingArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [settingArray[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor colorWithRed:81.0/255.0f green:81.0/255.0f blue:81.0/255.0f alpha:1.0f];
    cell.textLabel.text = settingArray[indexPath.section][indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *selectedString = settingArray[indexPath.section][indexPath.row];
    
    if ([selectedString isEqualToString:@"意见反馈"]) {
        [self feedBack];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"关于" message:@"嘿嘿" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (IBAction)closeSetting:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)feedBack{
    // 反馈
    // 判断此iPhone的邮箱是否打开
    if ([MFMailComposeViewController canSendMail]) {
        // 写邮件界面
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        // 邮件的标题
        [picker setSubject:@"一键拨号 - 意见反馈"];
        
        // 接收用户发送的邮件的邮箱
        NSArray *toRecipients = [NSArray arrayWithObject:@"kylinzhangyingjie@126.com"];
        NSString *infoString = [self getDeviceInfo];
        [picker setMessageBody:infoString isHTML:NO];
        [picker setToRecipients:toRecipients];
        
        
        [self presentViewController:picker animated:YES completion:^{
            
        }];
        
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在您的设置中打开“邮件”！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    

}
//    邮箱的协议方法，当点击发送或者取消时调用：
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(NSString *)getDeviceInfo{
    NSString *systemVersion = [[UIDevice currentDevice]systemVersion];
    NSString *modelName = nil;
    NSDictionary *infoDic = [NSBundle mainBundle].infoDictionary;
    
    // 获取 App 的版本号
    NSString *appVersion = infoDic[@"CFBundleShortVersionString"];
    // 获取 App 的 build 版本
    NSString *appBuildVersion = infoDic[@"CFBundleVersion"];
    // 获取 App 的名称
    NSString *appName = infoDic[@"CFBundleDisplayName"];
    
    return [NSString stringWithFormat:@"\n\n\n 系统版本：\%@\n App版本：\%@",systemVersion,appVersion];
}

@end
