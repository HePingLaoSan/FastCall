//
//  FCContactCreationViewController.m
//  FastCall
//
//  Created by 和平老三 on 2017/5/8.
//  Copyright © 2017年 zhangyingjie. All rights reserved.
//

#import "FCContactCreationViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "FCContactCreationHeaderView.h"
#import "FCContactCreationCell.h"

static CGFloat headerViewHeight = 150.0f;

static NSString *const kFCContactCreationCellIdentifier = @"FCContactCreationCellIdentifier";

@interface FCContactCreationViewController ()
{
    FCContactCreationHeaderView *headerView;
}

@end

@implementation FCContactCreationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    headerView = [[FCContactCreationHeaderView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_myTableView.frame), headerViewHeight)];
    _myTableView.tableHeaderView = headerView;
    
    UINib *nib = [UINib nibWithNibName:@"FCContactCreationCell" bundle:nil];
    [_myTableView registerNib:nib forCellReuseIdentifier:kFCContactCreationCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
