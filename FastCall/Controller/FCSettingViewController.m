//
//  FCSettingViewController.m
//  FastCall
//
//  Created by zhangyingjie on 2017/4/28.
//  Copyright © 2017年 zhangyingjie. All rights reserved.
//

#import "FCSettingViewController.h"

@interface FCSettingViewController ()<UITableViewDelegate, UITableViewDataSource>
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
    
    settingArray = @[@[@"查看教程"],@[@"问题反馈"],@[@"关于"],];
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
}

- (IBAction)closeSetting:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
